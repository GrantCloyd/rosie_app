web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -c 2
release: rake bin/rails db:create
release: rake bin/rails db:migrate
release: rake bin/rails db:seed