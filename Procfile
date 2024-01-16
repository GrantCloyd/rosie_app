web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -c 2
release: rake db:create
release: rake db:migrate
release: rake db:seed