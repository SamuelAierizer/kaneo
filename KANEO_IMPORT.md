# Kaneo Bulk User Import

Kaneo has **no public admin API** for creating users. This imports users directly
into the Postgres database. The scripts and schema below were verified against the
[Kaneo source](https://github.com/usekaneo/kaneo) and
[better-auth](https://github.com/better-auth/utils) so logins actually work.

## TL;DR

```bash
# 1. Generate temp passwords -> output/kaneo-users-YYYY-MM-DD.csv
bun scripts/import-kaneo-users-mcp.ts users.json LhIxmSD05hGmCsTQzJMJilWVv68PKmhL example.com

# 2. Generate a TEST SQL for 1 user only (import this first!)
bun scripts/generate-db-import.ts output/kaneo-users-YYYY-MM-DD.csv LhIxmSD05hGmCsTQzJMJilWVv68PKmhL output/test-1-user.sql --limit=1 --reset

# 3. Run test-1-user.sql in the DB, then log in as that user to confirm it works

# 4. Generate the full import and run it
bun scripts/generate-db-import.ts output/kaneo-users-YYYY-MM-DD.csv LhIxmSD05hGmCsTQzJMJilWVv68PKmhL output/import.sql --reset

# 5. Share the CSV credentials with users
```

> **`--reset`** deletes the listed emails before inserting (cascades to their
> account + membership), so the file is **safe to run more than once**. Omit it
> only if you're 100% sure none of these emails exist yet.

> Workspace `LhIxmSD05hGmCsTQzJMJilWVv68PKmhL` = **RR 1** (confirmed via MCP).

## How to run the SQL in Coolify

You need a `psql` shell inside the Postgres container. Pick whichever you have access to:

### Option A — Coolify Terminal (easiest)
1. Coolify → your **Kaneo** project → the **Postgres** database resource.
2. Open the **Terminal** tab (gives you a shell inside the DB container).
3. Connect with psql:
   ```bash
   psql -U $POSTGRES_USER -d $POSTGRES_DB
   ```
   (Env vars are already set inside the container. If unset, check the database
   resource's **Environment Variables** in Coolify for user/db/password.)
4. Paste the contents of `output/test-1-user.sql`, press Enter. You should see
   `INSERT 0 1` lines and `COMMIT`.

### Option B — SSH + docker exec
1. SSH into the server hosting Coolify.
2. Find the Postgres container:
   ```bash
   docker ps | grep postgres
   ```
3. Pipe the SQL file straight in:
   ```bash
   docker exec -i <container_name> psql -U <user> -d <db> < output/test-1-user.sql
   ```
   (Copy the `.sql` file to the server first, e.g. with `scp`.)

### Option C — A GUI (TablePlus / DBeaver / pgAdmin)
1. In Coolify, expose the DB port or use an SSH tunnel to reach Postgres.
2. Connect with the credentials from the Coolify database resource.
3. Open a SQL editor, paste the file contents, run it.

After the test user imports, **log in to Kaneo** with that user's email + temp
password from the CSV. If it works, run the full `import.sql` the same way.

## What the SQL does

For each user it inserts into three tables (all verified against Kaneo's schema):

1. **`user`** — `email_verified = true` so no verification email is needed.
2. **`account`** — `provider_id = 'credential'`, `account_id = user.id`, and a
   **bcrypt (cost 10) `$2b$10$...` password hash** — matching Kaneo's `auth.ts`,
   which overrides better-auth's default scrypt with `bcrypt.hash(pw, 10)`.
3. **`workspace_member`** — adds the user to the workspace as `member`.

Everything is wrapped in a single `BEGIN … COMMIT` transaction. With `--reset` the
listed emails are deleted first, so the file is fully re-runnable.

## Scripts

### `scripts/import-kaneo-users-mcp.ts`
Generates temp passwords + emails.

```bash
bun scripts/import-kaneo-users-mcp.ts <input-file> <workspace-id> [email-domain]
```
- **Input**: JSON or CSV of names (+ optional emails)
- **Output**: `output/kaneo-users-YYYY-MM-DD.csv` and `.json`

### `scripts/generate-db-import.ts`
Turns that CSV into ready-to-run SQL (bcrypt-hashed passwords, correct schema).

```bash
bun scripts/generate-db-import.ts <csv-file> <workspace-id> [output-file] [--limit=N] [--reset]
```
- **`--limit=N`**: only generate SQL for the first N users (use `--limit=1` to test)
- **`--reset`**: delete the listed emails first, making the SQL safely re-runnable
- **Output**: a `.sql` file (or stdout if no output file given)

### `scripts/manage-kaneo-users.ts`
Generates SQL to update profile pictures / emails after import.

```bash
# Profile pictures (avatars.csv: Email,avatarUrl)
bun scripts/manage-kaneo-users.ts generate-profile-picture-sql avatars.csv avatarUrl avatars.sql

# Email changes (emails.csv: Email,realEmail)
bun scripts/manage-kaneo-users.ts generate-email-update-sql emails.csv realEmail emails.sql
```

## Input formats

`users.json`:
```json
[
  { "name": "John Smith" },
  { "name": "Jane Doe", "email": "jane@company.com" }
]
```

`users.csv`:
```csv
Name,Email
John Smith,
Jane Doe,jane@company.com
```
If `email` is omitted, it's auto-generated as `firstname.lastname@<domain>`.

## After import

- Send each user their email + temporary password from the CSV.
- They log in and change the password in **Settings → Security**.
- (Optional) set avatars / real emails with `manage-kaneo-users.ts`.

## Troubleshooting

| Symptom | Cause / Fix |
|---|---|
| `relation "user" does not exist` | Wrong DB. Connect to Kaneo's database, not `postgres`. |
| `duplicate key`/FK error on re-run | Regenerate with `--reset` (deletes the emails first) so the import is re-runnable. |
| Login says invalid credentials | Confirm the password matches the CSV; hashing is bcrypt cost 10 and cross-tested, so it's usually a typo or wrong email. |
| User logs in but sees no workspace | The `workspace_member` row didn't insert; check the workspace ID is `LhIxmSD05hGmCsTQzJMJilWVv68PKmhL`. |

## Verified facts (so you don't have to re-check)

- **No admin API** — Kaneo exposes no HTTP endpoint to create users.
- **Tables** are `user`, `account`, `workspace_member` with **snake_case** columns.
- **Credential account**: `account_id = user.id`, `provider_id = 'credential'`.
- **Password hash**: **bcrypt cost 10** (`$2b$10$...`). Kaneo's `auth.ts` overrides
  better-auth's default scrypt with `bcrypt.hash(pw, 10)` / `bcrypt.compare`. The
  generated hashes were cross-tested: the real `bcrypt` npm package's
  `bcrypt.compare` accepts them (`true` for the right password, `false` otherwise).
