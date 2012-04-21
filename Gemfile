source :rubygems

# If you make any changes in this file, please run `bundle install`.
# If new versions of your installed gems are available, run `bundle update`

gem "radiant", "~> 1.0.1"
gem 'hpricot'

# alternatively, in development
# gem "radiant", :path => "/path/to/radiant/root"

# Uncomment to support CoffeeScript with a JS runtime (used in the Sheets extension)
# gem "execjs"
# And you may need one of these:
# gem "mustang" # Google V8 for Ruby
# gem "therubyracer" # Google V8 for Ruby
# gem "therubyrhino" # Mozilla Rhino for JRuby
# gem "johnson" # Mozilla SpiderMonkey for Ruby

gem "mysql", "~> 2.8.1"

# Language packs
# gem "radiant-dutch_language_pack-extension",    "~> 1.0.0"
# gem "radiant-french_language_pack-extension",   "~> 1.0.0"
# gem "radiant-german_language_pack-extension",   "~> 1.0.0"
# gem "radiant-italian_language_pack-extension",  "~> 1.0.0"
# gem "radiant-japanese_language_pack-extension", "~> 1.0.0"
# gem "radiant-russian_language_pack-extension",  "~> 1.0.0"

gem "radiant-navigation_tags-extension", "~> 0.2.6", :git => 'git://github.com/enspiral/navigation_tags.git'
gem "radiant-ck_editor_filter-extension", "~> 0.2.5"
gem "radiant-settings-extension", "~> 1.1.1", :git => 'git@github.com:enspiral/radiant-settings.git'
gem 'radiant-mailer-extension'

# If you're running tests or specs
group :test, :cucumber do
  gem "cucumber-rails",   "~> 0.3.2"
  gem "database_cleaner", "~> 0.6.5"
  gem "webrat",           "~> 0.7.3"
  gem "rspec-rails",      "~> 1.3.3"
  gem "sqlite3",          "~> 1.3.4"
  gem 'autotest'
  gem 'autotest-fsevent'
  gem 'autotest-growl'
end

group :development do
  gem 'capistrano'
end