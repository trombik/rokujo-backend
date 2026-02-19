source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.1"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 2.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:windows, :jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use ViewComponent for UI components
gem "view_component"

# Use bootsnap for CSS
gem "bootstrap", "~> 5.3"
gem "dartsass-rails", "~> 0.5.1"
gem "jquery-rails", "~> 4.6"

# Use pagy for pagination
gem "pagy", "~> 43.2"

# Use ruby-spacy for NLP
gem "ruby-spacy", "~> 0.3.0"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: [:mri, :windows], require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # https://github.com/thoughtbot/factory_bot_rails
  gem "factory_bot_rails"

  gem "faker"
  gem "htmlbeautifier", "~> 1.4"
  gem "rspec-rails", "~> 8.0"
  gem "rubocop-capybara", "~> 2.22"
  gem "rubocop-factory_bot", "~> 2.28"
  gem "rubocop-rails", "~> 2.33"
  gem "rubocop-rspec", "~> 3.8"
  gem "rubocop-rspec_rails", "~> 2.32"
  gem "shoulda-matchers"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  gem "foreman"

  gem "guard", "~> 2.19"
  gem "guard-shell", "~> 0.7.2"
  gem "rb-kqueue", ">= 0.2", install_if: -> { RbConfig::CONFIG["target_os"] =~ /bsd|dragonfly/i }

  # Use lookbook for UI development
  gem "lookbook", ">= 2.3.13"
  # Install listen and actioncable gems to enable live-updating of the UI when
  # changes are made to component or preview files. The two are indirectly
  # installed via other dependencies but explicitly install them here to
  # indicate the gems are required for development.
  gem "actioncable"
  gem "listen"

  # Use pry for debugging
  gem "pry"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end

gem "activerecord-import", "~> 2.2"
