import * as fs from "fs";
import { createReadStream } from "fs";
import { createInterface } from "readline";
import { randomBytes } from "node:crypto";

// Bun runtime global (this script is run with `bun`). Declared locally to avoid
// requiring @types/bun in this project.
declare const Bun: {
  password: {
    hash(
      password: string,
      options: { algorithm: "bcrypt"; cost: number }
    ): Promise<string>;
  };
};

// ---------------------------------------------------------------------------
// Password hashing — MUST match Kaneo's auth config, which overrides the
// better-auth default (scrypt) with bcrypt:
//   hash:   bcrypt.hash(password, 10)
//   verify: bcrypt.compare(password, hash)
// Verified against: github.com/usekaneo/kaneo/blob/main/apps/api/src/auth.ts
//
// Bun.password.hash with { algorithm: "bcrypt", cost: 10 } produces a standard
// `$2b$10$...` hash that the `bcrypt` npm package's bcrypt.compare accepts.
// ---------------------------------------------------------------------------
const BCRYPT_COST = 10;

const hashPassword = async (password: string): Promise<string> => {
  return await Bun.password.hash(password, {
    algorithm: "bcrypt",
    cost: BCRYPT_COST,
  });
};

// ---------------------------------------------------------------------------
// ID generation — Kaneo uses @paralleldrive/cuid2 (24-char, starts with letter).
// Any unique text PK is valid; we mimic the cuid2 shape to stay consistent.
// ---------------------------------------------------------------------------
const generateId = (): string => {
  const letters = "abcdefghijklmnopqrstuvwxyz";
  const alphanum = "abcdefghijklmnopqrstuvwxyz0123456789";
  let id = letters.charAt(Math.floor(Math.random() * letters.length));
  const bytes = randomBytes(23);
  for (let i = 0; i < 23; i++) {
    id += alphanum.charAt(bytes[i] % alphanum.length);
  }
  return id;
};

// SQL string literal escaping (single quotes doubled).
const sql = (value: string): string => `'${value.replace(/'/g, "''")}'`;

interface CsvRow {
  Name: string;
  Email: string;
  "Temporary Password": string;
}

const readCsvFile = (filePath: string): Promise<Record<string, string>[]> =>
  new Promise((resolve, reject) => {
    const rows: Record<string, string>[] = [];
    const rl = createInterface({
      input: createReadStream(filePath),
      crlfDelay: Infinity,
    });

    let headers: string[] = [];
    let isFirstLine = true;

    const parseLine = (line: string): string[] => {
      // Minimal CSV parser handling quoted fields.
      const result: string[] = [];
      let current = "";
      let inQuotes = false;
      for (let i = 0; i < line.length; i++) {
        const char = line[i];
        if (char === '"') {
          if (inQuotes && line[i + 1] === '"') {
            current += '"';
            i++;
          } else {
            inQuotes = !inQuotes;
          }
        } else if (char === "," && !inQuotes) {
          result.push(current);
          current = "";
        } else {
          current += char;
        }
      }
      result.push(current);
      return result.map((s) => s.trim());
    };

    rl.on("line", (line) => {
      if (!line.trim()) return;
      const values = parseLine(line);
      if (isFirstLine) {
        headers = values;
        isFirstLine = false;
        return;
      }
      const row: Record<string, string> = {};
      headers.forEach((header, index) => {
        row[header] = values[index] || "";
      });
      rows.push(row);
    });

    rl.on("close", () => resolve(rows));
    rl.on("error", reject);
  });

const main = async () => {
  const args = process.argv.slice(2);
  const flags = args.filter((a) => a.startsWith("--"));
  const positional = args.filter((a) => !a.startsWith("--"));

  const limitFlag = flags.find((f) => f.startsWith("--limit="));
  const limit = limitFlag ? parseInt(limitFlag.split("=")[1], 10) : undefined;
  const reset = flags.includes("--reset");

  if (positional.length < 2) {
    console.error(
      "Usage: bun generate-db-import.ts <csv-file> <workspace-id> [output-file] [--limit=N]"
    );
    console.error(
      "\nExamples:"
    );
    console.error(
      "  # Test with 1 user:"
    );
    console.error(
      "  bun generate-db-import.ts output/kaneo-users.csv WORKSPACE_ID output/test-1-user.sql --limit=1"
    );
    console.error(
      "  # Full import:"
    );
    console.error(
      "  bun generate-db-import.ts output/kaneo-users.csv WORKSPACE_ID output/import.sql"
    );
    console.error(
      "\nFlags:"
    );
    console.error(
      "  --limit=N  Only generate SQL for the first N users"
    );
    console.error(
      "  --reset    Delete these emails first (makes the SQL safely re-runnable)"
    );
    process.exit(1);
  }

  const [csvFile, workspaceId, outputFile] = positional;

  if (!fs.existsSync(csvFile)) {
    console.error(`CSV file not found: ${csvFile}`);
    process.exit(1);
  }

  console.log(`Reading users from ${csvFile}...`);
  let rows = await readCsvFile(csvFile);

  if (limit !== undefined) {
    rows = rows.slice(0, limit);
    console.log(`--limit=${limit} -> generating SQL for ${rows.length} user(s)`);
  }
  console.log(`Found ${rows.length} users\n`);

  const header: string[] = [];
  header.push("-- Kaneo bulk user import");
  header.push(`-- Generated: ${new Date().toISOString()}`);
  header.push(`-- Workspace: ${workspaceId}`);
  header.push("-- Schema verified against usekaneo/kaneo apps/api/src/database/schema.ts");
  header.push("-- Password hashing: bcrypt cost 10 ($2b$10$...) matching Kaneo auth.ts");
  header.push("--");
  if (reset) {
    header.push("-- --reset: deletes these emails (and their account/member/session");
    header.push("-- rows) first, so this file is safe to run repeatedly.");
  } else {
    header.push("-- Run once on a clean DB. Re-run with --reset to make it idempotent.");
  }

  const userBlocks: string[] = [];
  const emails: string[] = [];

  for (const row of rows) {
    const name = row["Name"] || "";
    const email = (row["Email"] || "").toLowerCase();
    const tempPassword = row["Temporary Password"] || "";

    if (!name || !email || !tempPassword) {
      console.warn(`Skipping row with missing data: ${JSON.stringify(row)}`);
      continue;
    }

    emails.push(email);
    const userId = generateId();
    const accountId = generateId();
    const memberId = generateId();
    const passwordHash = await hashPassword(tempPassword);

    console.log(`  ${name} <${email}>`);

    userBlocks.push(`-- ${name} <${email}>`);

    // 1. user — email_verified=true so they can log in without verification email
    userBlocks.push(
      `INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)`
    );
    userBlocks.push(
      `VALUES (${sql(userId)}, ${sql(name)}, ${sql(email)}, true, NOW(), NOW(), false, false)`
    );
    userBlocks.push(`ON CONFLICT (email) DO NOTHING;`);

    // 2. account — credential provider. account_id = user.id (better-auth convention)
    userBlocks.push(
      `INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)`
    );
    userBlocks.push(
      `VALUES (${sql(accountId)}, ${sql(userId)}, 'credential', ${sql(userId)}, ${sql(passwordHash)}, NOW(), NOW());`
    );

    // 3. workspace_member — grants access to the workspace
    userBlocks.push(
      `INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)`
    );
    userBlocks.push(
      `VALUES (${sql(memberId)}, ${sql(workspaceId)}, ${sql(userId)}, 'member', NOW());`
    );
    userBlocks.push("");
  }

  const lines: string[] = [];
  lines.push("\\set ON_ERROR_STOP on");
  lines.push(...header, "", "BEGIN;", "");
  if (reset && emails.length > 0) {
    const emailList = emails.map((e) => sql(e)).join(", ");
    const userIds = `SELECT id FROM "user" WHERE email IN (${emailList})`;
    lines.push("-- Clean slate for the imported emails. Child rows are deleted");
    lines.push("-- explicitly (not relying on ON DELETE CASCADE) for safety.");
    lines.push(`DELETE FROM "session" WHERE user_id IN (${userIds});`);
    lines.push(`DELETE FROM "account" WHERE user_id IN (${userIds});`);
    lines.push(`DELETE FROM "workspace_member" WHERE user_id IN (${userIds});`);
    lines.push(`DELETE FROM "user" WHERE email IN (${emailList});`);
    lines.push("");
  }
  lines.push(...userBlocks);
  lines.push("COMMIT;");
  lines.push("");
  // Post-commit verification so you can SEE the result in psql output.
  lines.push("-- Verification: each imported user should show provider_id");
  lines.push("-- 'credential' and pw_prefix '$2b$'. A NULL account means failure.");
  const emailList = emails.map((e) => sql(e)).join(", ");
  lines.push(
    `SELECT u.email, a.provider_id, left(a.password, 4) AS pw_prefix,`
  );
  lines.push(
    `       (m.id IS NOT NULL) AS in_workspace`
  );
  lines.push(`FROM "user" u`);
  lines.push(`LEFT JOIN "account" a ON a.user_id = u.id`);
  lines.push(
    `LEFT JOIN "workspace_member" m ON m.user_id = u.id AND m.workspace_id = ${sql(workspaceId)}`
  );
  lines.push(
    `WHERE u.email IN (${emailList.length > 0 ? emailList : "''"})`
  );
  lines.push(`ORDER BY u.email;`);
  lines.push("");

  const output = lines.join("\n");

  if (outputFile) {
    fs.writeFileSync(outputFile, output);
    console.log(`\nSQL written to ${outputFile}`);
  } else {
    console.log("\n" + output);
  }

  console.log("\nNext steps:");
  console.log("  1. Review the SQL file");
  console.log("  2. Run it against your Kaneo Postgres DB (see KANEO_IMPORT.md)");
  console.log("  3. Test login with one user before importing the rest");
};

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
