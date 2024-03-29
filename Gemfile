source 'https://rubygems.org'

# If you make any changes in this file, please run `bundle install`.
# If new versions of your installed gems are available, run `bundle update`

# Because LTS
git 'https://github.com/makandra/rails.git', branch: '2-3-lts' do
  gem 'rails', '~>2.3.18'
  gem 'actionmailer',     require: false
  gem 'actionpack',       require: false
  gem 'activerecord',     require: false
  gem 'activeresource',   require: false
  gem 'activesupport',    require: false
  gem 'railties',         require: false
  gem 'railslts-version', require: false
end
gem "rspec", "=1.3.2", git: 'https://github.com/makandra/rspec.git', branch: '1-3-lts'
gem 'rspec-rails', git: 'https://github.com/makandra/rspec-rails.git', branch: '1-3-lts'
gem 'irb', require: false

# this breaks specs.. but is necessary for attachements i think
gem "radiant", git: "git://github.com/nzffa/radiant", branch: 'with_rails_lts'
# gem "radiant", :path => "../radiant"

gem "rdoc", "6.3.2"
gem "rake", "10.5.0"

gem "RedCloth", "~> 4.2.9"

gem 'hpricot'
gem 'httparty', '0.10.0'
gem 'sanitize', '2.0.3'
gem 'mime-types', '1.22'

gem "mysql2", "~> 0.5.3"
gem "activerecord-mysql2-adapter"
# gem "rack-cache", "1.2"
gem "execjs", "2.0.0"
gem "ref", "1.0.5"
gem "therubyracer"

gem 'whenever', '0.9.4', :require => false

# Default Extensions
# gem "radiant-archive-extension",             "~> 1.0.7"
# gem "radiant-debug-extension",               "~> 1.0.2"
# gem "radiant-exporter-extension",            "~> 1.1.0"
# gem "radiant-markdown_filter-extension",     "~> 1.0.2"
gem "radiant-sheets-extension",              "~> 1.1.0"
gem "radiant-snippets-extension",            "~> 1.1.3"
# gem "radiant-site_templates-extension",      "~> 1.0.6"
# gem "radiant-smarty_pants_filter-extension", "~> 1.0.2"
# gem "radiant-textile_filter-extension",      "~> 1.0.4"
# Language packs
# gem "radiant-dutch_language_pack-extension",    "~> 1.0.0"
# gem "radiant-french_language_pack-extension",   "~> 1.0.0"
# gem "radiant-german_language_pack-extension",   "~> 1.0.0"
# gem "radiant-italian_language_pack-extension",  "~> 1.0.0"
# gem "radiant-japanese_language_pack-extension", "~> 1.0.0"
# gem "radiant-russian_language_pack-extension",  "~> 1.0.0"

gem "radiant-clipped-extension", :git => 'git://github.com/radiant/radiant-clipped-extension.git', :branch => :with_rails_lts
# gem "radiant-clipped-extension", :path => "vendor/extensions/clipped"

# This depends on radiant-layouts-extension
gem 'radiant-reader-extension', :git => 'git://github.com/jomz/radiant-reader-extension.git', :branch => :with_rails_lts
# gem 'radiant-reader-extension', :path => 'vendor/extensions/reader'

gem "radiant-forum-extension", :git => 'git://github.com/nzffa/radiant-forum-extension.git', :branch => :wackamole
# gem "radiant-forum-extension", :path => 'vendor/extensions/forum'

gem "radiant-page_reader_group_permissions-extension", :git => 'git://github.com/nzffa/radiant-page_reader_group_permissions-extension.git'
# gem "radiant-page_reader_group_permissions-extension", :path => 'vendor/extensions/page_reader_group_permissions'

# gem "radiant-conference-extension", :path => 'vendor/extensions/conference'
gem "radiant-conference-extension", :git => 'git://github.com/nzffa/radiant-nzffa_conference-extension.git'

# gem "radiant-marketplace-extension", :path => 'vendor/extensions/marketplace'
# gem "spreadsheet"
gem "radiant-marketplace-extension", :git => 'git://github.com/nzffa/radiant-nzffa_marketplace-extension.git'

gem "radiant-reorder_children-extension"
gem 'radiant-relations-extension'
# gem 'radiant-relations-extension', :path => 'vendor/extensions/relations'
gem "radiant-linx-extension"

# gem "radiant-downloads-extension", :path => 'vendor/extensions/downloads'
gem "radiant-downloads-extension", :git => 'git://github.com/nzffa/radiant-downloads-extension.git'
gem "radiant-scheduler-extension", :git => "git://github.com/nzffa/radiant-scheduler-extension", :branch => :with_rails_lts
# gem "radiant-scheduler-extension", :path => "vendor/extensions/scheduler"
gem "radiant-navigation_tags-extension", "~> 0.2.7"
gem "radiant-ck_editor_filter-extension", "~> 0.2.5"
gem "radiant-settings-extension", "~> 1.1.1", :git => 'git://github.com/enspiral/radiant-settings.git'
gem 'radiant-mailer-extension'
gem "radiant-search-extension"
gem "radiant-copy_move-extension",          "~> 2.4.9"
# gem "radiant-copy_move-extension", :path => 'vendor/extensions/copy_move'
gem "radiant-grandchildren_tags-extension"
gem "radiant-if_id_tags-extension"
gem "radiant-html_tags-extension"
gem "radiant-find_by_id_tag-extension", "~> 1.2.3"
# gem 'radiant-find_by_id_tag-extension', :path => 'vendor/extensions/find_by_id_tag'
gem "radiant-find_replace-extension", "~> 1.0.6"
# gem "radiant-find_replace-extension", :path => 'vendor/extensions/find_replace'
gem "radiant-if_date_tags-extension", "~> 1.0.0"

gem 'radiant-layouts-extension', :git => 'git://github.com/enspiral/radiant-share-layouts-extension.git'
# The above gem uses rr for mocking
gem 'rr', :group => :test

gem 'backup', :git => 'git://github.com/jdutil/backup.git'
# gem 'fog', '1.1.0'
gem 'net-ssh', '4.2.0'
gem 'multi_json', '~> 1.3.0'
gem 'parallel', '~> 0.5.12'

# gem 'xero_gateway', :path => 'vendor/xero_gateway'
gem 'oauth', '0.5.5'
gem 'oauth2', '1.4.7'
gem 'xeroizer', :git => 'git@github.com:nzffa/xeroizer.git', :branch => :rails_2_lts
# gem 'xeroizer', :path => 'vendor/xeroizer'

group :production, :staging do
  gem 'airbrake', '4.1.0'
end

# If you're running tests or specs
group :test, :cucumber, :development do
  #gem 'vcr'
  #gem 'webmock'
  # gem 'rspec-nc'
  # gem 'webrat'
  # gem 'rspec-rails', '1.3.4'
  # gem 'rspec', '1.3.2'
  # gem "capybara", "1.1.1"
  # gem 'timecop'
  # #gem "capybara-webkit"
  # gem 'launchy'
  # gem "cucumber", "1.1.0"
  # gem "cucumber-rails", :git => 'https://github.com/robguthrie/cucumber-rails.git', :branch => 'v0.3.2fixed'
  # gem "database_cleaner",  " >= 0.5.0"
end

group :development do
  gem 'capistrano', "~> 2.14.1"
end
