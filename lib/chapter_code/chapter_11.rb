# chapter 11

# create a new rails application with postgresql database
rails new posgresql-gems --database=postgresql

# install acts-as-taggable-on gem
bundle add acts-as-taggable-on
Fetching gem metadata from https://rubygems.org/........
Resolving dependencies...
Fetching gem metadata from https://rubygems.org/........
Fetching acts-as-taggable-on 13.0.0
Installing acts-as-taggable-on 13.0.0

# create the new application database
bin/rails db:create
Created database 'posgresql_gems_development'
Created database 'posgresql_gems_test'

# create a new repository on github
gh repo create posgresql-gems --public --source=. --remote=origin --push

# copy the migration files from the gem source to the application source
bin/rails acts_as_taggable_on_engine:install:migrations
Copied migration 20260921063501_acts_as_taggable_on_migration.acts_as_taggable_on_engine.rb from acts_as_taggable_on_engine
Copied migration 20260921063502_add_missing_unique_indices.acts_as_taggable_on_engine.rb from acts_as_taggable_on_engine
Copied migration 20260921063503_add_taggings_counter_cache_to_tags.acts_as_taggable_on_engine.rb from acts_as_taggable_on_engine
Copied migration 20260921063504_add_missing_taggable_index.acts_as_taggable_on_engine.rb from acts_as_taggable_on_engine
Copied migration 20260921063505_change_collation_for_tag_names.acts_as_taggable_on_engine.rb from acts_as_taggable_on_engine
Copied migration 20260921063506_add_missing_indexes_on_taggings.acts_as_taggable_on_engine.rb from acts_as_taggable_on_engine
Copied migration 20260921063507_add_tenant_to_taggings.acts_as_taggable_on_engine.rb from acts_as_taggable_on_engine

# apply the migrations copied from the gem
bin/rails db:migrate

# connect to the development database
bin/rails dbconsole
psql (16.9 (Homebrew))
Type "help" for help.

posgresql_gems_development=# 

# describe tables
\dt
List of relations
Schema |         Name         | Type  | Owner 
--------+----------------------+-------+-------
public | ar_internal_metadata | table | scan
public | schema_migrations    | table | scan
public | taggings             | table | scan
public | tags                 | table | scan
(4 rows)

# describe the taggings table
\d taggings
Table "public.taggings"
Column        |            Type             | Collation | Nullable |               Default                
--------------+-----------------------------+-----------+----------+--------------------------------------
id            | bigint                      |           | not null | nextval('taggings_id_seq'::regclass)
tag_id        | bigint                      |           |          | 
taggable_type | character varying           |           |          | 
taggable_id   | bigint                      |           |          | 
tagger_type   | character varying           |           |          | 
tagger_id     | bigint                      |           |          | 
context       | character varying(128)      |           |          | 
created_at    | timestamp without time zone |           |          | 
tenant        | character varying(128)      |           |          | 
Indexes:
"taggings_pkey" PRIMARY KEY, btree (id)
"index_taggings_on_context" btree (context)
"index_taggings_on_tag_id" btree (tag_id)
"index_taggings_on_taggable_id" btree (taggable_id)
"index_taggings_on_taggable_type" btree (taggable_type)
"index_taggings_on_taggable_type_and_taggable_id" btree (taggable_type, taggable_id)
"index_taggings_on_tagger_id" btree (tagger_id)
"index_taggings_on_tagger_id_and_tagger_type" btree (tagger_id, tagger_type)
"index_taggings_on_tagger_type_and_tagger_id" btree (tagger_type, tagger_id)
"index_taggings_on_tenant" btree (tenant)
"taggings_idx" UNIQUE, btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type)
"taggings_idy" btree (taggable_id, taggable_type, tagger_id, context)
"taggings_taggable_context_idx" btree (taggable_id, taggable_type, context)
Foreign-key constraints:
"fk_rails_9fcd2e236b" FOREIGN KEY (tag_id) REFERENCES tags(id)

# describe the tags table
\d tags
                                            Table "public.tags"
     Column     |              Type              | Collation | Nullable |             Default              
----------------+--------------------------------+-----------+----------+----------------------------------
 id             | bigint                         |           | not null | nextval('tags_id_seq'::regclass)
 name           | character varying              |           |          | 
 created_at     | timestamp(6) without time zone |           | not null | 
 updated_at     | timestamp(6) without time zone |           | not null | 
 taggings_count | integer                        |           |          | 0
Indexes:
  "tags_pkey" PRIMARY KEY, btree (id)
  "index_tags_on_name" UNIQUE, btree (name)
Referenced by:
  TABLE "taggings" CONSTRAINT "fk_rails_9fcd2e236b" FOREIGN KEY (tag_id) REFERENCES tags(id)

# generate a model to use with the tagging gem
bin/rails generate resource User name:string
invoke  active_record
The name 'User' is either already used in your application or reserved by Ruby on Rails. 
Please choose an alternative or use --skip-collision-check or --force to skip this check 
and run this generator again.

# run the migrations, this step isn't in the
bin/rails db:migrate
== 20260922074535 CreateUsers: migrating ======================================
-- create_table(:users)
   -> 0.0285s
== 20260922074535 CreateUsers: migrated (0.0286s) =============================

# new day form page 251

# start psql session
bin/rails dbconsole

# Run vacuum and analyze
VACUUM (ANALYZE, VERBOSE) users, tags, taggings;

INFO:  vacuuming "posgresql_gems_development.public.users"
INFO:  finished vacuuming "posgresql_gems_development.public.users": index scans: 0
pages: 0 removed, 1 remain, 1 scanned (100.00% of total)
tuples: 0 removed, 1 remain, 0 are dead but not yet removable
removable cutoff: 6477397, which was 0 XIDs old when operation ended
new relfrozenxid: 6466844, which is 8 XIDs ahead of previous value
new relminmxid: 296611, which is 1470 MXIDs ahead of previous value
frozen: 0 pages from table (0.00% of total) had 0 tuples frozen
index scan not needed: 0 pages from table (0.00% of total) had 0 dead item identifiers removed
avg read rate: 5.320 MB/s, avg write rate: 4.560 MB/s
buffer usage: 35 hits, 7 misses, 6 dirtied
WAL usage: 2 records, 2 full page images, 15661 bytes
system usage: CPU: user: 0.00 s, system: 0.00 s, elapsed: 0.01 s
INFO:  vacuuming "posgresql_gems_development.pg_toast.pg_toast_10292554"
INFO:  finished vacuuming "posgresql_gems_development.pg_toast.pg_toast_10292554": index scans: 0
pages: 0 removed, 0 remain, 0 scanned (100.00% of total)
tuples: 0 removed, 0 remain, 0 are dead but not yet removable
removable cutoff: 6477397, which was 0 XIDs old when operation ended
new relfrozenxid: 6477397, which is 10561 XIDs ahead of previous value
new relminmxid: 296611, which is 1470 MXIDs ahead of previous value
frozen: 0 pages from table (100.00% of total) had 0 tuples frozen
index scan not needed: 0 pages from table (100.00% of total) had 0 dead item identifiers removed
avg read rate: 5.549 MB/s, avg write rate: 0.000 MB/s
buffer usage: 26 hits, 1 misses, 0 dirtied
WAL usage: 1 records, 0 full page images, 188 bytes
system usage: CPU: user: 0.00 s, system: 0.00 s, elapsed: 0.00 s
INFO:  analyzing "public.users"
INFO:  "users": scanned 1 of 1 pages, containing 1 live rows and 0 dead rows; 1 rows in sample, 1 estimated total rows
INFO:  vacuuming "posgresql_gems_development.public.tags"
INFO:  finished vacuuming "posgresql_gems_development.public.tags": index scans: 0
pages: 0 removed, 0 remain, 0 scanned (100.00% of total)
tuples: 0 removed, 0 remain, 0 are dead but not yet removable
removable cutoff: 6477398, which was 0 XIDs old when operation ended
new relfrozenxid: 6477398, which is 18802 XIDs ahead of previous value
new relminmxid: 296611, which is 2576 MXIDs ahead of previous value
frozen: 0 pages from table (100.00% of total) had 0 tuples frozen
index scan not needed: 0 pages from table (100.00% of total) had 0 dead item identifiers removed
avg read rate: 19.654 MB/s, avg write rate: 0.000 MB/s
buffer usage: 32 hits, 2 misses, 0 dirtied
WAL usage: 1 records, 0 full page images, 188 bytes
system usage: CPU: user: 0.00 s, system: 0.00 s, elapsed: 0.00 s
INFO:  vacuuming "posgresql_gems_development.pg_toast.pg_toast_10288136"
INFO:  finished vacuuming "posgresql_gems_development.pg_toast.pg_toast_10288136": index scans: 0
pages: 0 removed, 0 remain, 0 scanned (100.00% of total)
tuples: 0 removed, 0 remain, 0 are dead but not yet removable
removable cutoff: 6477398, which was 0 XIDs old when operation ended
new relfrozenxid: 6477398, which is 18802 XIDs ahead of previous value
new relminmxid: 296611, which is 2576 MXIDs ahead of previous value
frozen: 0 pages from table (100.00% of total) had 0 tuples frozen
index scan not needed: 0 pages from table (100.00% of total) had 0 dead item identifiers removed
avg read rate: 16.587 MB/s, avg write rate: 0.000 MB/s
buffer usage: 19 hits, 1 misses, 0 dirtied
WAL usage: 1 records, 0 full page images, 188 bytes
system usage: CPU: user: 0.00 s, system: 0.00 s, elapsed: 0.00 s
INFO:  analyzing "public.tags"
INFO:  "tags": scanned 0 of 0 pages, containing 0 live rows and 0 dead rows; 0 rows in sample, 0 estimated total rows
INFO:  vacuuming "posgresql_gems_development.public.taggings"
INFO:  finished vacuuming "posgresql_gems_development.public.taggings": index scans: 0
pages: 0 removed, 0 remain, 0 scanned (100.00% of total)
tuples: 0 removed, 0 remain, 0 are dead but not yet removable
removable cutoff: 6477398, which was 0 XIDs old when operation ended
new relfrozenxid: 6477398, which is 18802 XIDs ahead of previous value
new relminmxid: 296611, which is 2576 MXIDs ahead of previous value
frozen: 0 pages from table (100.00% of total) had 0 tuples frozen
index scan not needed: 0 pages from table (100.00% of total) had 0 dead item identifiers removed
avg read rate: 14.034 MB/s, avg write rate: 0.000 MB/s
buffer usage: 189 hits, 13 misses, 0 dirtied
WAL usage: 1 records, 0 full page images, 188 bytes
system usage: CPU: user: 0.00 s, system: 0.00 s, elapsed: 0.00 s
INFO:  vacuuming "posgresql_gems_development.pg_toast.pg_toast_10288145"
INFO:  finished vacuuming "posgresql_gems_development.pg_toast.pg_toast_10288145": index scans: 0
pages: 0 removed, 0 remain, 0 scanned (100.00% of total)
tuples: 0 removed, 0 remain, 0 are dead but not yet removable
removable cutoff: 6477398, which was 0 XIDs old when operation ended
new relfrozenxid: 6477398, which is 18802 XIDs ahead of previous value
new relminmxid: 296611, which is 2576 MXIDs ahead of previous value
frozen: 0 pages from table (100.00% of total) had 0 tuples frozen
index scan not needed: 0 pages from table (100.00% of total) had 0 dead item identifiers removed
avg read rate: 8.079 MB/s, avg write rate: 0.000 MB/s
buffer usage: 19 hits, 1 misses, 0 dirtied
WAL usage: 1 records, 0 full page images, 188 bytes
system usage: CPU: user: 0.00 s, system: 0.00 s, elapsed: 0.00 s
INFO:  analyzing "public.taggings"
INFO:  "taggings": scanned 0 of 0 pages, containing 0 live rows and 0 dead rows; 0 rows in sample, 0 estimated total rows
VACUUM

# set the enable_seqscan to off to try and force indexes to be used
enable_seqscan = OFF

# start a rails console session
bin/rails console

# turn on logging
ActiveRecord::Base.logger = Logger.new(STDOUT)

# command from earlier that I forgot to add to this doc
# User.create(name: 'Jess')

# add a tag to my user
User.find_by(name: 'Jess').tag_list.add('surfer')

D, [2026-09-23T08:54:34.025232 #93504] DEBUG -- :   User Load (1.7ms)  SELECT "users".* FROM "users" WHERE "users"."name" = 'Jess' LIMIT 1 /*application='PosgresqlGems'*/
D, [2026-09-23T08:54:34.056019 #93504] DEBUG -- :   ActsAsTaggableOn::Tagging Load (5.2ms)  SELECT "taggings".* FROM "taggings" WHERE "taggings"."taggable_id" = 1 AND "taggings"."taggable_type" = 'User' /*application='PosgresqlGems'*/
D, [2026-09-23T08:54:34.071629 #93504] DEBUG -- :   ActsAsTaggableOn::Tag Load (2.1ms)  SELECT "tags".* FROM "tags" INNER JOIN "taggings" ON "tags"."id" = "taggings"."tag_id" WHERE "taggings"."taggable_id" = 1 AND "taggings"."taggable_type" = 'User' AND (taggings.context = 'tags' AND taggings.tagger_id IS NULL) /*application='PosgresqlGems'*/
=> ["surfer"]

jess = User.last
D, [2026-09-23T08:59:56.764562 #93504] DEBUG -- :   User Load (3.4ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT 1 /*application='PosgresqlGems'*/

jess
=> 
#<User:0x000000012175b7d8
 id: 1,
 name: "Jess",
 created_at: "2026-09-22 08:10:16.301921000 +0000",
 updated_at: "2026-09-22 08:10:16.301921000 +0000",
 tag_list: nil>

jess.taggings
D, [2026-09-23T09:00:52.619800 #93504] DEBUG -- :   ActsAsTaggableOn::Tagging Load (1.5ms)  SELECT"taggings".* FROM "taggings" WHERE "taggings"."taggable_id" = 1 AND "taggings"."taggable_type" = 'User' /* loading for pp */ LIMIT 11 /*application='PosgresqlGems'*/
=> []

jess.tagging_contexts
D, [2026-09-23T09:00:56.743511 #93504] DEBUG -- :   ActsAsTaggableOn::Tagging Load (0.7ms)  SELECT"taggings".* FROM "taggings" WHERE "taggings"."taggable_id" = 1 AND "taggings"."taggable_type" = 'User' /*application='PosgresqlGems'*/
=> ["tags"]

ActsAsTaggableOn::Tag.all
D, [2026-09-23T09:08:14.708098 #93504] DEBUG -- :   ActsAsTaggableOn::Tag Load (19.7ms)  SELECT "tags".* FROM "tags" /* loading for pp */ LIMIT 11 /*application='PosgresqlGems'*/
=> []

ActsAsTaggableOn::Tagging.all
D, [2026-09-23T09:08:33.189775 #93504] DEBUG -- :   ActsAsTaggableOn::Tagging Load (33.7ms)  SELECT "taggings".* FROM "taggings"/* loading for pp */ LIMIT 11 /*application='PosgresqlGems'*/
=> []

jess.tag_list.add("surfer")
D, [2026-09-23T09:12:15.103531 #93504] DEBUG -- :   ActsAsTaggableOn::Tag Load (3.7ms)  SELECT "tags".* FROM "tags" INNER JOIN "taggings" ON "tags"."id" = "taggings"."tag_id" WHERE "taggings"."taggable_id" = 1 AND "taggings"."taggable_type" = 'User' AND (taggings.context = 'tags' AND taggings.tagger_id IS NULL) /*application='PosgresqlGems'*/
=> ["surfer"]

jess.save!
D, [2026-09-23T09:12:20.067449 #93504] DEBUG -- :   TRANSACTION (1.1ms)  BEGIN /*application='PosgresqlGems'*/
D, [2026-09-23T09:12:20.073763 #93504] DEBUG -- :   ActsAsTaggableOn::Tag Load (7.5ms)  SELECT "tags".* FROM "tags" WHERE (LOWER(name) = LOWER('surfer')) /*application='PosgresqlGems'*/
D, [2026-09-23T09:12:20.080319 #93504] DEBUG -- :   TRANSACTION (1.6ms)  SAVEPOINT active_record_1 /*application='PosgresqlGems'*/
D, [2026-09-23T09:12:20.081670 #93504] DEBUG -- :   ActsAsTaggableOn::Tag Exists? (3.1ms)  SELECT 1 AS one FROM "tags" WHERE "tags"."name" = 'surfer'LIMIT 1 /*application='PosgresqlGems'*/
D, [2026-09-23T09:12:20.098875 #93504] DEBUG -- :   ActsAsTaggableOn::Tag Create (14.1ms)  INSERT INTO "tags" ("name", "created_at", "updated_at", "taggings_count") VALUES ('surfer', '2026-09-23 08:12:20.082410', '2026-09-23 08:12:20.082410', 0) RETURNING "id" /*application='PosgresqlGems'*/
D, [2026-09-23T09:12:20.100752 #93504] DEBUG -- :   TRANSACTION (1.2ms)  RELEASE SAVEPOINT active_record_1 /*application='PosgresqlGems'*/
D, [2026-09-23T09:12:20.105335 #93504] DEBUG -- :   ActsAsTaggableOn::Tag Load (3.1ms)  SELECT "tags".* FROM "tags" INNER JOIN "taggings" ON "tags"."id" = "taggings"."tag_id" WHERE "taggings"."taggable_id" = 1 AND "taggings"."taggable_type" = 'User' AND (taggings.context = 'tags' AND taggings.tagger_id IS NULL) /*application='PosgresqlGems'*/
D, [2026-09-23T09:12:20.134965 #93504] DEBUG -- :   ActsAsTaggableOn::Tag Load (8.4ms)  SELECT "tags".* FROM "tags" WHERE "tags"."id" = 1 LIMIT 1 /*application='PosgresqlGems'*/
D, [2026-09-23T09:12:20.136564 #93504] DEBUG -- :   ActsAsTaggableOn::Tagging Exists? (0.9ms)  SELECT 1 AS one FROM "taggings" WHERE "taggings"."tag_id" = 1 AND "taggings"."taggable_type" = 'User' AND "taggings"."taggable_id" = 1 AND "taggings"."context" = 'tags' AND "taggings"."tagger_id" IS NULL AND "taggings"."tagger_type" IS NULL LIMIT 1 /*application='PosgresqlGems'*/
D, [2026-09-23T09:12:20.144512 #93504] DEBUG -- :   ActsAsTaggableOn::Tagging Create (7.5ms)  INSERT INTO "taggings" ("tag_id", "taggable_type", "taggable_id", "tagger_type", "tagger_id", "context", "created_at", "tenant") VALUES (1, 'User', 1, NULL, NULL, 'tags', '2026-09-23 08:12:20.136699', NULL) RETURNING "id" /*application='PosgresqlGems'*/
D, [2026-09-23T09:12:20.147611 #93504] DEBUG -- :   ActsAsTaggableOn::Tag Update All (2.2ms)  UPDATE "tags" SET "taggings_count" = COALESCE("taggings_count", 0) + 1 WHERE "tags"."id" = 1 /*application='PosgresqlGems'*/
D, [2026-09-23T09:12:20.150976 #93504] DEBUG -- :   TRANSACTION (3.0ms)  COMMIT /*application='PosgresqlGems'*/
=> true

jess.taggings
=> [#<ActsAsTaggableOn::Tagging:0x0000000122bea820 id: 1, tag_id: 1, taggable_type: "User", taggable_id: 1, tagger_type: nil, tagger_id: nil, context: "tags", created_at: "2026-09-23 08:12:20.136699000 +0000", tenant: nil>]

jess.tags
D, [2026-09-23T09:17:41.301158 #93504] DEBUG -- :   ActsAsTaggableOn::Tag Load (14.2ms)  SELECT "tags".* FROM "tags" INNER JOIN "taggings" ON "tags"."id" = "taggings"."tag_id" WHERE "taggings"."taggable_id" = 1 AND "taggings"."taggable_type" = 'User' AND "taggings"."context" = 'tags' /* loading for pp */ LIMIT 11 /*application='PosgresqlGems'*/
=> [#<ActsAsTaggableOn::Tag:0x000000012410e4e0 id: 1, name: "surfer", created_at: "2026-09-23 08:12:20.082410000 +0000", updated_at: "2026-09-23 08:12:20.082410000 +0000", taggings_count: 1>]

jess.tag_list
=> ["surfer"]
jess.ta
ActsAsTaggableOn::Tag.all
posgresql-gems(dev)> 
D, [2026-09-23T09:18:08.317972 #93504] DEBUG -- :   ActsAsTaggableOn::Tag Load (2.6ms)  SELECT "tags".* FROM "tags" /* loading for pp */ LIMIT 11 /*application='PosgresqlGems'*/
=> [#<ActsAsTaggableOn::Tag:0x000000012410caa0 id: 1, name: "surfer", created_at: "2026-09-23 08:12:20.082410000 +0000", updated_at: "2026-09-23 08:12:20.082410000 +0000", taggings_count: 1>]

ActsAsTaggableOn::Tagging.all
D, [2026-09-23T09:18:24.803851 #93504] DEBUG -- :   ActsAsTaggableOn::Tagging Load (3.6ms)  SELECT "taggings".* FROM "taggings" /* loading for pp */ LIMIT 11 /*application='PosgresqlGems'*/
=> [#<ActsAsTaggableOn::Tagging:0x000000012410c460 id: 1, tag_id: 1, taggable_type: "User", taggable_id: 1, tagger_type: nil, tagger_id: nil, context: "tags", created_at: "2026-09-23 08:12:20.136699000 +0000", tenant: nil>]