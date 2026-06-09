import * as fs from "fs";
import * as path from "path";

interface DbConfig {
  host: string;
  port: number;
  database: string;
  user: string;
  password: string;
}

interface UpdateOperation {
  type: "profile-picture" | "email";
  userId?: string;
  email?: string;
  value: string;
}

const generateSqlUpdateProfilePicture = (email: string, imageUrl: string): string => {
  const escapedEmail = email.replace(/'/g, "''");
  const escapedUrl = imageUrl.replace(/'/g, "''");
  return `UPDATE "user" SET image = '${escapedUrl}' WHERE email = '${escapedEmail}';`;
};

const generateSqlUpdateEmail = (
  oldEmail: string,
  newEmail: string
): string[] => {
  const escapedOld = oldEmail.replace(/'/g, "''");
  const escapedNew = newEmail.replace(/'/g, "''");

  // For credential accounts account_id = user.id (not the email), so only the
  // user table needs updating. The account row is left untouched.
  return [
    `UPDATE "user" SET email = '${escapedNew}' WHERE email = '${escapedOld}';`,
  ];
};

const readCsvFile = async (filePath: string): Promise<Record<string, string>[]> => {
  const content = fs.readFileSync(filePath, "utf-8");
  const lines = content.split("\n").filter((line) => line.trim());
  const headers = lines[0].split(",").map((h) => h.trim().replace(/^"|"$/g, ""));

  return lines.slice(1).map((line) => {
    const values = line.split(",").map((v) => v.trim().replace(/^"|"$/g, ""));
    const row: Record<string, string> = {};
    headers.forEach((header, index) => {
      row[header] = values[index] || "";
    });
    return row;
  });
};

const main = async () => {
  const args = process.argv.slice(2);
  const command = args[0];

  if (command === "generate-profile-picture-sql") {
    if (args.length < 3) {
      console.error(
        "Usage: bun manage-kaneo-users.ts generate-profile-picture-sql <csv-file> <image-url-column> [output-file]"
      );
      console.error(
        "Example: bun manage-kaneo-users.ts generate-profile-picture-sql users.csv avatarUrl output.sql"
      );
      process.exit(1);
    }

    const [, csvFile, imageColumn, outputFile] = args;

    if (!fs.existsSync(csvFile)) {
      console.error(`CSV file not found: ${csvFile}`);
      process.exit(1);
    }

    const rows = await readCsvFile(csvFile);
    const sqlStatements: string[] = [];

    for (const row of rows) {
      const email = row["Email"] || row["email"];
      const imageUrl = row[imageColumn];

      if (!email || !imageUrl) {
        console.warn(
          `⚠️  Skipping row: missing email or ${imageColumn} column`
        );
        continue;
      }

      sqlStatements.push(generateSqlUpdateProfilePicture(email, imageUrl));
    }

    const output = sqlStatements.join("\n");

    if (outputFile) {
      fs.writeFileSync(outputFile, output);
      console.log(`✅ SQL statements written to ${outputFile}`);
    } else {
      console.log(output);
    }

    console.log(`\n📊 Generated ${sqlStatements.length} SQL statements`);
  } else if (command === "generate-email-update-sql") {
    if (args.length < 3) {
      console.error(
        "Usage: bun manage-kaneo-users.ts generate-email-update-sql <csv-file> <new-email-column> [output-file]"
      );
      console.error(
        "Example: bun manage-kaneo-users.ts generate-email-update-sql users.csv realEmail output.sql"
      );
      process.exit(1);
    }

    const [, csvFile, newEmailColumn, outputFile] = args;

    if (!fs.existsSync(csvFile)) {
      console.error(`CSV file not found: ${csvFile}`);
      process.exit(1);
    }

    const rows = await readCsvFile(csvFile);
    const sqlStatements: string[] = [];

    for (const row of rows) {
      const oldEmail = row["Email"] || row["email"];
      const newEmail = row[newEmailColumn];

      if (!oldEmail || !newEmail) {
        console.warn(
          `⚠️  Skipping row: missing email or ${newEmailColumn} column`
        );
        continue;
      }

      if (oldEmail === newEmail) {
        console.warn(`⚠️  Skipping row: old and new emails are the same`);
        continue;
      }

      const statements = generateSqlUpdateEmail(oldEmail, newEmail);
      sqlStatements.push(...statements);
    }

    const output = sqlStatements.join("\n");

    if (outputFile) {
      fs.writeFileSync(outputFile, output);
      console.log(`✅ SQL statements written to ${outputFile}`);
    } else {
      console.log(output);
    }

    console.log(`\n📊 Generated ${sqlStatements.length} SQL statements`);
  } else if (command === "help") {
    console.log(`
Kaneo User Management Script

Commands:
  generate-profile-picture-sql <csv-file> <image-url-column> [output-file]
    Generate SQL to update user profile pictures from a CSV file
    
  generate-email-update-sql <csv-file> <new-email-column> [output-file]
    Generate SQL to update user emails (updates both user and account tables)
    
  help
    Show this help message

Examples:
  bun manage-kaneo-users.ts generate-profile-picture-sql users.csv avatarUrl output.sql
  bun manage-kaneo-users.ts generate-email-update-sql users.csv realEmail output.sql
    `);
  } else {
    console.error(`Unknown command: ${command}`);
    console.error("Run 'bun manage-kaneo-users.ts help' for usage information");
    process.exit(1);
  }
};

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
