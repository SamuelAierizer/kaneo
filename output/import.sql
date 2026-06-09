\set ON_ERROR_STOP on
-- Kaneo bulk user import
-- Generated: 2026-06-08T17:49:05.309Z
-- Workspace: LhIxmSD05hGmCsTQzJMJilWVv68PKmhL
-- Schema verified against usekaneo/kaneo apps/api/src/database/schema.ts
-- Password hashing: bcrypt cost 10 ($2b$10$...) matching Kaneo auth.ts
--
-- --reset: deletes these emails (and their account/member/session
-- rows) first, so this file is safe to run repeatedly.

BEGIN;

-- Clean slate for the imported emails. Child rows are deleted
-- explicitly (not relying on ON DELETE CASCADE) for safety.
DELETE FROM "session" WHERE user_id IN (SELECT id FROM "user" WHERE email IN ('kovakovics314@gmail.com', 'enikovincze76@gmail.com', 'petervinczevp@gmail.com', 'halmagyi47@gmail.com', 'orsi.borovszky@gmail.com', 'biro.lajos30@gmail.com', 'pistukapeti@gmail.com', '19791207enci@gmail.com', 'kporsi85@gmail.com', 'istvan.borovszky@gmail.com', 'kovacs.ninuska@gmail.com', 'bolgarbrigi@gmail.com', 'andrearado82@gmail.com', 'kovacszoltan20010@gmail.com', 'rad.zoltan@example.com', 'mihnea@example.com', 'rad.ron@example.com', 'halmgyi.ruth@example.com', 'nechifor.lena@example.com', 'nechifor.marcel@example.com', 'theodora.sava@example.com'));
DELETE FROM "account" WHERE user_id IN (SELECT id FROM "user" WHERE email IN ('kovakovics314@gmail.com', 'enikovincze76@gmail.com', 'petervinczevp@gmail.com', 'halmagyi47@gmail.com', 'orsi.borovszky@gmail.com', 'biro.lajos30@gmail.com', 'pistukapeti@gmail.com', '19791207enci@gmail.com', 'kporsi85@gmail.com', 'istvan.borovszky@gmail.com', 'kovacs.ninuska@gmail.com', 'bolgarbrigi@gmail.com', 'andrearado82@gmail.com', 'kovacszoltan20010@gmail.com', 'rad.zoltan@example.com', 'mihnea@example.com', 'rad.ron@example.com', 'halmgyi.ruth@example.com', 'nechifor.lena@example.com', 'nechifor.marcel@example.com', 'theodora.sava@example.com'));
DELETE FROM "workspace_member" WHERE user_id IN (SELECT id FROM "user" WHERE email IN ('kovakovics314@gmail.com', 'enikovincze76@gmail.com', 'petervinczevp@gmail.com', 'halmagyi47@gmail.com', 'orsi.borovszky@gmail.com', 'biro.lajos30@gmail.com', 'pistukapeti@gmail.com', '19791207enci@gmail.com', 'kporsi85@gmail.com', 'istvan.borovszky@gmail.com', 'kovacs.ninuska@gmail.com', 'bolgarbrigi@gmail.com', 'andrearado82@gmail.com', 'kovacszoltan20010@gmail.com', 'rad.zoltan@example.com', 'mihnea@example.com', 'rad.ron@example.com', 'halmgyi.ruth@example.com', 'nechifor.lena@example.com', 'nechifor.marcel@example.com', 'theodora.sava@example.com'));
DELETE FROM "user" WHERE email IN ('kovakovics314@gmail.com', 'enikovincze76@gmail.com', 'petervinczevp@gmail.com', 'halmagyi47@gmail.com', 'orsi.borovszky@gmail.com', 'biro.lajos30@gmail.com', 'pistukapeti@gmail.com', '19791207enci@gmail.com', 'kporsi85@gmail.com', 'istvan.borovszky@gmail.com', 'kovacs.ninuska@gmail.com', 'bolgarbrigi@gmail.com', 'andrearado82@gmail.com', 'kovacszoltan20010@gmail.com', 'rad.zoltan@example.com', 'mihnea@example.com', 'rad.ron@example.com', 'halmgyi.ruth@example.com', 'nechifor.lena@example.com', 'nechifor.marcel@example.com', 'theodora.sava@example.com');

-- Kovacs Anna <kovakovics314@gmail.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('lzulo6d19amef2whcr7gwlt0', 'Kovacs Anna', 'kovakovics314@gmail.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('kvfh9bl8iso4zucqg2i88g1l', 'lzulo6d19amef2whcr7gwlt0', 'credential', 'lzulo6d19amef2whcr7gwlt0', '$2b$10$3vZ7P1N5TrT/8WeILQxl8e5LTi4DyxwNoNwYnn8Jq28ozqK1X7KVO', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('tfxbhg1xf3lncu2wew3lsfd0', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'lzulo6d19amef2whcr7gwlt0', 'member', NOW());

-- Vincze Eniko <enikovincze76@gmail.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('ieebtanh3qcvprap5p076uhy', 'Vincze Eniko', 'enikovincze76@gmail.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('thx20dbdumi2d2b7gm66gs60', 'ieebtanh3qcvprap5p076uhy', 'credential', 'ieebtanh3qcvprap5p076uhy', '$2b$10$sTkKhfWa/IHWdajSFn1jaOWeL18/bfNVMWF9bbr8LSZk4rQi9/Fpy', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('v7obbrobzauk2247wwxkmjme', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'ieebtanh3qcvprap5p076uhy', 'member', NOW());

-- Vincze Peter <petervinczevp@gmail.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('f0bfxs2kgab64f0db592ff7s', 'Vincze Peter', 'petervinczevp@gmail.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('tg6ti7ku986fubg7aa3mbobq', 'f0bfxs2kgab64f0db592ff7s', 'credential', 'f0bfxs2kgab64f0db592ff7s', '$2b$10$u/GXtN8vfWpfNrVywtUSWu65IusFTprQ17.Z7FdV/xPiWtRuklS7i', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('v3d457n9f5kz0y42n0v7u1de', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'f0bfxs2kgab64f0db592ff7s', 'member', NOW());

-- Halmagyi Ruben <halmagyi47@gmail.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('pxff7bsaipoqioc34hh8ghto', 'Halmagyi Ruben', 'halmagyi47@gmail.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('ad0wl74cjjstk8xrzsw9oz3m', 'pxff7bsaipoqioc34hh8ghto', 'credential', 'pxff7bsaipoqioc34hh8ghto', '$2b$10$.yXMQ8if2sO84cLLq7ezu.NpyQe1aV1bX0euYEVJPgo0Imv9saGL6', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('bi9ol1lym8vl1hhysecavxax', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'pxff7bsaipoqioc34hh8ghto', 'member', NOW());

-- Borovszky Orsi <orsi.borovszky@gmail.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('ipctdhg85d8jlristbnv5f34', 'Borovszky Orsi', 'orsi.borovszky@gmail.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('syn9qfkojzwqnpguax5tk45j', 'ipctdhg85d8jlristbnv5f34', 'credential', 'ipctdhg85d8jlristbnv5f34', '$2b$10$uetoYfAMEriNdxYse2YlfuVtnKxAjurZOqWuEvfmAiBwgxY6C4w02', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('iv0xbw845c37yh91y1vckmj3', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'ipctdhg85d8jlristbnv5f34', 'member', NOW());

-- Biro Lajos <biro.lajos30@gmail.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('zox1fq0yrdvee12sprmc0er2', 'Biro Lajos', 'biro.lajos30@gmail.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('i9anr67cp3pxs2idy3ya96sn', 'zox1fq0yrdvee12sprmc0er2', 'credential', 'zox1fq0yrdvee12sprmc0er2', '$2b$10$P.O21yf57/J5q7sQVuifwu3.XwW3.jJe7kLy//2fxdY0N3rQdL7.C', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('od7y07vccubdsl70m2bcumqu', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'zox1fq0yrdvee12sprmc0er2', 'member', NOW());

-- Kovacs Peter <pistukapeti@gmail.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('wxd9feabhhdspne0unxoic85', 'Kovacs Peter', 'pistukapeti@gmail.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('sogdm45maa04pkhcjm2s9m6e', 'wxd9feabhhdspne0unxoic85', 'credential', 'wxd9feabhhdspne0unxoic85', '$2b$10$i6.yz78muQ6kN0SOc.Pl/uU8UPVCLI6a4KrTLmRWpBb9DqxZfaY7O', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('w2oddfdb8e93n6688j7pwrxx', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'wxd9feabhhdspne0unxoic85', 'member', NOW());

-- Varga Enikő <19791207enci@gmail.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('muc8gt6k89b4zo5alpnuhydz', 'Varga Enikő', '19791207enci@gmail.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('ygd13p4y2cc5mo2r88fimjbl', 'muc8gt6k89b4zo5alpnuhydz', 'credential', 'muc8gt6k89b4zo5alpnuhydz', '$2b$10$9zVt2/EmMVyf0KGgRJAmg.pGSXZAMy8aybGLPJPhlHHco4gsBLnlS', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('jwt1oxe70lmzybe94wiusvw6', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'muc8gt6k89b4zo5alpnuhydz', 'member', NOW());

-- Antal Orsolya <kporsi85@gmail.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('bxdfvxc4oybvjx29v2xkfh2j', 'Antal Orsolya', 'kporsi85@gmail.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('y4mraj376ebqvarwi0q6tsb5', 'bxdfvxc4oybvjx29v2xkfh2j', 'credential', 'bxdfvxc4oybvjx29v2xkfh2j', '$2b$10$lapuK0WvaBClG3PhuzuY/ehKlPSNJmIYhAg9D9t5DOn5tYrVbAbtq', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('f2ckcucdttyzliugn9iwabyo', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'bxdfvxc4oybvjx29v2xkfh2j', 'member', NOW());

-- Borovszky István <istvan.borovszky@gmail.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('t0bdqxxtu0yt0anh3sstpcyi', 'Borovszky István', 'istvan.borovszky@gmail.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('h0jkroa2loiqgze5vqa8bb2i', 't0bdqxxtu0yt0anh3sstpcyi', 'credential', 't0bdqxxtu0yt0anh3sstpcyi', '$2b$10$Rv5vI5Qb/upS43rcJNdUJuf5HvKTzAYjHseDCUBBMqhRo2rpj/rTG', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('pub0gdsmhvyubhazc8lm616u', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 't0bdqxxtu0yt0anh3sstpcyi', 'member', NOW());

-- Kovács Szidónia <kovacs.ninuska@gmail.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('q4qw6n6ribzmgkgg7lpvgk7v', 'Kovács Szidónia', 'kovacs.ninuska@gmail.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('z9bnymhubz0zr0wgpi94m7ey', 'q4qw6n6ribzmgkgg7lpvgk7v', 'credential', 'q4qw6n6ribzmgkgg7lpvgk7v', '$2b$10$PC7sdaQncBxs0CWvIsjdDOUjrqVEIwV5Y5bD9nwjaMdA7IdFN1ruC', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('qh4oupox72s6y3vga5hr7x6f', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'q4qw6n6ribzmgkgg7lpvgk7v', 'member', NOW());

-- Bolgar Brigitta <bolgarbrigi@gmail.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('v99vjgxejoqs3uk5n38pwj0d', 'Bolgar Brigitta', 'bolgarbrigi@gmail.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('lrsiq6wawb67zcwr2jc6sgwa', 'v99vjgxejoqs3uk5n38pwj0d', 'credential', 'v99vjgxejoqs3uk5n38pwj0d', '$2b$10$bzCC59IsOzVSt0NOEYy8G.COL9f5z2T.Xik3yDJlKFNoxcABl5/pu', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('qnx16sak1fnnj4rlbe254gva', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'v99vjgxejoqs3uk5n38pwj0d', 'member', NOW());

-- Radó Andrea <andrearado82@gmail.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('h1t8r7fhoi7lb8ud9yfupaod', 'Radó Andrea', 'andrearado82@gmail.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('dxboj2artco57e231j9cphle', 'h1t8r7fhoi7lb8ud9yfupaod', 'credential', 'h1t8r7fhoi7lb8ud9yfupaod', '$2b$10$ALbIkD3yZ8iLtzENJMDaPedbbEvaOVZNh/RK7pxwb9p6hy8c6JaBO', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('iu6xyaa9zelcwc5lhm7fn0im', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'h1t8r7fhoi7lb8ud9yfupaod', 'member', NOW());

-- Kovács P. Zoltán <kovacszoltan20010@gmail.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('hvfwibmppop4dkvs1cay0nt0', 'Kovács P. Zoltán', 'kovacszoltan20010@gmail.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('mlz62aj3nmrbnbc59z36l2m9', 'hvfwibmppop4dkvs1cay0nt0', 'credential', 'hvfwibmppop4dkvs1cay0nt0', '$2b$10$Q/91VFyRLHRECb9.9cO7VOMUnTHY3CO2QKL4zxVBpLOZ/7t/qAD0q', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('qf0ykgfndr7sdkknwhszt9u2', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'hvfwibmppop4dkvs1cay0nt0', 'member', NOW());

-- Radó Zoltan <rad.zoltan@example.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('hadh8pncgy6di0y7xoyppl5h', 'Radó Zoltan', 'rad.zoltan@example.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('sjot0m53gooc4yi10bev9mge', 'hadh8pncgy6di0y7xoyppl5h', 'credential', 'hadh8pncgy6di0y7xoyppl5h', '$2b$10$L4iY82yBZE6XrdnBDKryyuEr/TcLm77BQe00qgKapfqlXZ2lB9WyK', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('sk584sod7ic6en1rjpr3on22', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'hadh8pncgy6di0y7xoyppl5h', 'member', NOW());

-- Mihnea <mihnea@example.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('i3svlbf30mk3lrp8isv99xnd', 'Mihnea', 'mihnea@example.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('un2yxb4umzimtha7iknhjxw2', 'i3svlbf30mk3lrp8isv99xnd', 'credential', 'i3svlbf30mk3lrp8isv99xnd', '$2b$10$YISXWEohjGd8AN30d1TRz.8LlO5XBd26U3e2L1LIHO7ZMDXskspUa', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('jtv99vm7p6at14mjgl6943r4', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'i3svlbf30mk3lrp8isv99xnd', 'member', NOW());

-- Radó Áron <rad.ron@example.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('b6zg62sov3om2waopde1nfno', 'Radó Áron', 'rad.ron@example.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('ghzhkr44otp1xqogfrxn72zs', 'b6zg62sov3om2waopde1nfno', 'credential', 'b6zg62sov3om2waopde1nfno', '$2b$10$.WqcVog.0oM4u/UWs9KHF.QPIa2VsiO9nsL5MUpTppKxUEZiRuVIu', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('znesn2xw0b5vmk7qn2fcphti', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'b6zg62sov3om2waopde1nfno', 'member', NOW());

-- Halmágyi Ruth <halmgyi.ruth@example.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('o24yws1zxlh1httzn8kla4fc', 'Halmágyi Ruth', 'halmgyi.ruth@example.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('szwwbylqhuxbxp9mlb1avrqc', 'o24yws1zxlh1httzn8kla4fc', 'credential', 'o24yws1zxlh1httzn8kla4fc', '$2b$10$JulrFoRIabagzOByXWWuWu1sqTUwE1hruqah1sdszg0opMQDBcbLq', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('lndie6dq2xbk21lzvnk47i4n', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'o24yws1zxlh1httzn8kla4fc', 'member', NOW());

-- Nechifor Lena <nechifor.lena@example.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('o75zetpyukr093eg0wu3oesr', 'Nechifor Lena', 'nechifor.lena@example.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('a894d26us1ndgi7b0czglzcr', 'o75zetpyukr093eg0wu3oesr', 'credential', 'o75zetpyukr093eg0wu3oesr', '$2b$10$Gr3dFToZs920EX94sHAom.8k4LxtQjvCH1u719OEFNv5pMbN.o8F.', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('eev4cnhxtbnvct69wqvksb9m', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'o75zetpyukr093eg0wu3oesr', 'member', NOW());

-- Nechifor Marcel <nechifor.marcel@example.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('z8wpc59cyuzk4ja4tpngyet8', 'Nechifor Marcel', 'nechifor.marcel@example.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('kced1ltepksqoiz6hleqdpgt', 'z8wpc59cyuzk4ja4tpngyet8', 'credential', 'z8wpc59cyuzk4ja4tpngyet8', '$2b$10$L8nsy9hVFiWMYb9yui8nUuyRu2TBoF5Uj2YvY8NVDPkxLl95c2ebi', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('qmxymrcobcjrex1lenky36sp', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'z8wpc59cyuzk4ja4tpngyet8', 'member', NOW());

-- Theodora Sava <theodora.sava@example.com>
INSERT INTO "user" (id, name, email, email_verified, created_at, updated_at, banned, is_anonymous)
VALUES ('kfsmmw0rwhkrsaiqi5oxdqwy', 'Theodora Sava', 'theodora.sava@example.com', true, NOW(), NOW(), false, false)
ON CONFLICT (email) DO NOTHING;
INSERT INTO "account" (id, account_id, provider_id, user_id, password, created_at, updated_at)
VALUES ('xkdds2ic3g9w6xpu7d74vs1h', 'kfsmmw0rwhkrsaiqi5oxdqwy', 'credential', 'kfsmmw0rwhkrsaiqi5oxdqwy', '$2b$10$WXYAEoGhKGT2kvyxRFLUxeETdRa.rYKTsEkCGvfxY9KxcumlwFs16', NOW(), NOW());
INSERT INTO "workspace_member" (id, workspace_id, user_id, role, joined_at)
VALUES ('t3n07km73neeqwrxmbpunf7q', 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL', 'kfsmmw0rwhkrsaiqi5oxdqwy', 'member', NOW());

COMMIT;

-- Verification: each imported user should show provider_id
-- 'credential' and pw_prefix '$2b$'. A NULL account means failure.
SELECT u.email, a.provider_id, left(a.password, 4) AS pw_prefix,
       (m.id IS NOT NULL) AS in_workspace
FROM "user" u
LEFT JOIN "account" a ON a.user_id = u.id
LEFT JOIN "workspace_member" m ON m.user_id = u.id AND m.workspace_id = 'LhIxmSD05hGmCsTQzJMJilWVv68PKmhL'
WHERE u.email IN ('kovakovics314@gmail.com', 'enikovincze76@gmail.com', 'petervinczevp@gmail.com', 'halmagyi47@gmail.com', 'orsi.borovszky@gmail.com', 'biro.lajos30@gmail.com', 'pistukapeti@gmail.com', '19791207enci@gmail.com', 'kporsi85@gmail.com', 'istvan.borovszky@gmail.com', 'kovacs.ninuska@gmail.com', 'bolgarbrigi@gmail.com', 'andrearado82@gmail.com', 'kovacszoltan20010@gmail.com', 'rad.zoltan@example.com', 'mihnea@example.com', 'rad.ron@example.com', 'halmgyi.ruth@example.com', 'nechifor.lena@example.com', 'nechifor.marcel@example.com', 'theodora.sava@example.com')
ORDER BY u.email;
