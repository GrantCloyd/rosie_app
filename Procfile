release: bundle exec rake db:create
release: bundle exec rake db:migrate
release: bundle exec rake db:seed
web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -c 2