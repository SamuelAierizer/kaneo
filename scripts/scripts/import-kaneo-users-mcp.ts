import * as fs from "fs";
import * as path from "path";
import { createReadStream } from "fs";
import { createInterface } from "readline";

interface UserInput {
  name: string;
  email?: string;
}

interface UserOutput {
  name: string;
  email: string;
  tempPassword: string;
  userId?: string;
  status: "success" | "failed";
  error?: string;
}

const generatePassword = (): string => {
  const chars =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
  let password = "";
  for (let i = 0; i < 16; i++) {
    password += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return password;
};

const generateEmail = (name: string, domain: string): string => {
  const normalized = name
    .toLowerCase()
    .trim()
    .replace(/\s+/g, ".")
    .replace(/[^a-z0-9.]/g, "");
  return `${normalized}@${domain}`;
};

const readInputFile = async (filePath: string): Promise<UserInput[]> => {
  const ext = path.extname(filePath).toLowerCase();

  if (ext === ".json") {
    const content = fs.readFileSync(filePath, "utf-8");
    return JSON.parse(content) as UserInput[];
  }

  if (ext === ".csv") {
    return new Promise((resolve, reject) => {
      const users: UserInput[] = [];
      const rl = createInterface({
        input: createReadStream(filePath),
        crlfDelay: Infinity,
      });

      let isFirstLine = true;
      rl.on("line", (line) => {
        if (isFirstLine) {
          isFirstLine = false;
          return;
        }

        const [name, email] = line.split(",").map((s) => s.trim());
        if (name) {
          users.push({ name, email: email || undefined });
        }
      });

      rl.on("close", () => resolve(users));
      rl.on("error", reject);
    });
  }

  throw new Error("Unsupported file format. Use .json or .csv");
};

const main = async () => {
  const args = process.argv.slice(2);

  if (args.length < 2) {
    console.error(
      "Usage: bun import-kaneo-users-mcp.ts <input-file> <workspace-id> [email-domain]"
    );
    console.error(
      "Example: bun import-kaneo-users-mcp.ts users.json workspace-123 example.com"
    );
    console.error(
      "\nNote: This script generates a CSV template for bulk user creation."
    );
    console.error(
      "You will need to use the Kaneo UI or database to actually create the users."
    );
    process.exit(1);
  }

  const [inputFile, workspaceId, emailDomain = "internal.local"] = args;

  if (!fs.existsSync(inputFile)) {
    console.error(`Input file not found: ${inputFile}`);
    process.exit(1);
  }

  console.log(`📥 Reading users from ${inputFile}...`);
  const users = await readInputFile(inputFile);
  console.log(`✅ Found ${users.length} users\n`);

  const results: UserOutput[] = [];

  for (let i = 0; i < users.length; i++) {
    const user = users[i];
    const tempPassword = generatePassword();
    const email = user.email || generateEmail(user.name, emailDomain);

    console.log(`[${i + 1}/${users.length}] ${user.name} (${email})`);

    results.push({
      name: user.name,
      email,
      tempPassword,
      status: "success",
    });
  }

  console.log(`\n${"=".repeat(60)}`);
  console.log(`Generated credentials for ${results.length} users`);
  console.log(`${"=".repeat(60)}\n`);

  const timestamp = new Date().toISOString().split("T")[0];
  const outputCsv = `output/kaneo-users-${timestamp}.csv`;
  const outputJson = `output/kaneo-users-${timestamp}.json`;

  if (!fs.existsSync("output")) {
    fs.mkdirSync("output", { recursive: true });
  }

  const csvHeader = "Name,Email,Temporary Password,Workspace ID\n";
  const csvRows = results
    .map((r) => `"${r.name}","${r.email}","${r.tempPassword}","${workspaceId}"`)
    .join("\n");

  fs.writeFileSync(outputCsv, csvHeader + csvRows);
  fs.writeFileSync(outputJson, JSON.stringify(results, null, 2));

  console.log(`📄 Results saved to:`);
  console.log(`   CSV: ${outputCsv}`);
  console.log(`   JSON: ${outputJson}`);
  console.log(
    `\n⚠️  NEXT STEPS:`
  );
  console.log(
    `   1. Use the Kaneo UI to create users manually, OR`
  );
  console.log(
    `   2. Use direct database access to bulk-insert users with these credentials`
  );
  console.log(
    `   3. Share the CSV with users so they can log in with the temporary passwords`
  );
};

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
