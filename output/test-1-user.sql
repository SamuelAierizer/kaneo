\set ON_ERROR_STOP on
-- Kaneo bulk user import
-- Generated: 2026-06-08T17:49:05.230Z
-- Workspace: LhIxmSD05hGmCsTQzJMJilWVv68PKmhL
-- Schema verified against usekaneo/kaneo apps/api/src/database/schema.ts
-- Password hashing: bcrypt cost 10 ($2b$10$...) matching Kaneo auth.ts
--
-- --reset: deletes these emails (and their account/member/session
-- rows) first, so this file is safe to run repeatedly.

BEGIN;

-- Clean slate for the imported emails. Child rows are deleted
-- explicitly (not relying on ON DELETE CASCADE) for safety.
DELETE FROM "session" WHERE user_id IN (SELECT id FROM "user" WHERE email IN ('kovakovics314@gmail.com'));
DELETE FROM "account" WHERE user_id IN (SELECT id FROM "user" WHERE email IN ('kovakovics314@gmail.com'));
DELETE FROM "workspace_member" WHERE user_id IN (SELECT id FROM "user" WHERE email IN ('kovakovics314@gmail.com'));
DELETE FROM "user" WHERE email IN ('kovakovics314@gmail.com');

-- Kovacs Anna <kovakovics314@gmail.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('bckaq7zuip73mx9xjxcoohny', 'Kovacs Anna', 'kovakovics314@gmail.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('tbog27gvzg1awgs3pwto7pxi', 'bckaq7zuip73mx9xjxcoohny', 'credential', 'bckaq7zuip73mx9xjxcoohny', '$2b$10$j9RTHu8J4mWB2W2Q7vJW5eSOES7sI6wC3cQIBLGGVtO7O3mvSUeKe', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('hq2cp25adv0c1x4e8vlju5qm', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'bckaq7zuip73mx9xjxcoohny', 'member', NOW());

COMMIT;

-- Verification: each imported user should show provider_id
-- 'credential' and pw_prefix '$2b$'. A NULL account means failure.
SELECT u.email, a.provider_id, left(a.password, 4) AS pw_prefix,
       (m.id IS NOT NULL) AS in_workspace
FROM "user" u
LEFT JOIN "account" a ON a.user_id = u.id
LEFT JOIN "workspace_member" m ON m.user_id = u.id AND m.workspace_id = 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL'
WHERE u.email IN ('kovakovics314@gmail.com')
ORDER BY u.email;
