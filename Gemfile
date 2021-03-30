source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'devise', github: 'heartcombo/devise', branch: 'ca-omniauth-2'

gem 'autoprefixer-rails'
gem 'font-awesome-sass'
gem 'simple_form'

gem 'pg_search'
gem 'pundit'
gem 'wicked_pdf', '~> 1.1'
gem 'wkhtmltopdf-binary'
gem 'wkhtmltopdf-heroku', '2.12.5.0'
gem 'ckeditor', git: 'https://github.com/galetahub/ckeditor'
gem 'google-api-client', require: 'google/apis/calendar_v3'
gem 'google-apis-calendar_v3'
gem 'google-http-actionmailer'
gem 'oauth2'
gem "omniauth-rails_csrf_protection"
gem 'omniauth-google-oauth2'
gem 'rest-client', '~> 2.1'
gem 'uglifier'
gem 'jquery-rails'
gem 'acts_as_list'
gem "acts_as_tree"
gem "simple_calendar", "~> 2.0"
gem 'render_async'
gem 'image_processing'
gem 'invisible_captcha'
gem 'bootstrap',     '4.3.1'
gem 'material-sass', git: 'https://github.com/bricechapuis/material-sass'
gem 'exception_handler', '~> 0.8.0.0'
gem 'redis-rails'
gem 'sucker_punch', '~> 2.0'
gem 'ransack'
gem 'flatpickr'
gem 'trix-rails', require: 'trix'

group :development, :test do  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'dotenv-rails'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
