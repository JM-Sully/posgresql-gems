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
