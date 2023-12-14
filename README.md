# README

* Ruby/Rails versions
  - Ruby - 3.2.2
  - Rails - 7.1.2

* System dependencies
  - Postgresql@16
  - tailwind-css 
  - redis

* Database creation
  - Install postgresql service (ie `brew install postgresql@16` and make sure to add path to zshrc or bash config file per prompt)
  - start postgresql service (ie `brew service start postgresql@16` or similar linux service command)
  - `rails db:create && rails db:migrate && rails db:seed`

* Start App
  - install Ruby 3.2.2 (can use rbenv or asdf for version management)
  - install rails (`sudo gem install rails`) 
  - run `bundle` in root directory
  - build css - `rails tailwindcss:build`
  - create db/seed if you haven't already
  - `rails server`
  - open app on localhost:3000
  - profit

* For Sidekiq
  - install redis (`brew install redis` or similar)
  - start redis server
  - run sidekiq via `sidekiq` command in root directory


* ...
