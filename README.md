# README

* Ruby/Rails versions
  - Ruby - 3.3.0
  - Rails - 7.1.3

* System dependencies
  - Postgresql@16
  - tailwind-css 
  - redis

* Database creation
  - Install postgresql service (ie `brew install postgresql@16` and make sure to add path to zshrc or bash config file per prompt)
  - start postgresql service (ie `brew service start postgresql@16` or similar linux service command)
  - Note - if you'd like to use the seed file, this app uses the dotenv gem for local development and has smtp set up for local development 
    when sending emails as part of the invite to group flow. Create a .env file and add "SMTP_EMAIL" (an email address) and "ADMIN_SECRET" (whatever password you want to use). 
  - `rails db:create && rails db:migrate && rails db:seed`

* Start App
  - install Ruby 3.2.2 (can use rbenv or asdf for version management)
  - install rails (`sudo gem install rails`) 
  - run `bundle` in root directory
  - build or watch css - `rails tailwindcss:build` or `rails tailwind:watch` if you want to make changes and have it recompile
  - create db/seed if you haven't already
  - `rails server`
  - open app on localhost:3000
  - profit

* For GoodJob (Postgresql backed queue adapter for background jobs)
  - be sure to have run the database migrations (currently tethered to primary database)
  -  good_job is configured to run async which utiilizes background thread pool as part of running `rails server`
  - can run seperately locally via executing the `bundle exec good_job` command in root directory 
  after changing `config.good_job.execution_mode` from `:async` to `:external` in `config/environments/development`

* For Testing
  - This currently uses rails/minitest spec style approach with factory bot and mocha
  - You'll need to build the database for tests so `rails db:create RAILS_ENV=test && rails db:migrate RAILS_ENV=test`
  - run all using `bundle exec rails test`

When you've got everything running - you'll need to create a super admin user to actually create a group using the interface. You can use the seed method mentioned in the database creation section or create one by running `rails console` and creating a user with the `role` of `:super_admin`

