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
