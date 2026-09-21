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

# describe the tas table
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
