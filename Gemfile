source 'https://rubygems.org'
ruby "2.1.5"
# make JSON requests to APIs
gem 'httparty'
# Use paypal sdk to process payments
gem 'paypal-sdk-rest'
# Use env to hide variables
gem 'dotenv-rails', :groups => [:development, :test]
# Use omniauth-paypal for user login
gem "omniauth-paypal"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# stripe API
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'

# allow use of handlebars in rails views
gem 'handlebars_assets'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Use bootstrap, devise and pundit for user auth
gem 'bootstrap-sass'
gem 'devise'
gem 'pundit'

# Use sidekiq for background processing
gem 'sidekiq'
# Use sidetiq to schedule processes
gem 'sidetiq'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rails_db_info'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'spring-commands-rspec'
end

# the following are for devise/pundit
group :production do
  gem 'pg'
  gem 'rails_12factor'
end
group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
end
