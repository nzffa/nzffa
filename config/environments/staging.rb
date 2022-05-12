# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger        = SyslogLogger.new


# Full error reports are disabled and caching is on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :user_name => 'nzffa-staging-af9a6c9f38b7d9fa',
  :password => 'c75709194a0a5e24',
  :address => 'mailtrap.io',
  :port => '2525',
  :authentication => :plain,
}

config.after_initialize do
  SiteController.cache_timeout = 2.hours
end

# SMTP config is stored in a yml outside of the git repo
# Capistrano symlinks to the file in shared/config
ymlconf = YAML.load_file("#{Rails.root}/config/application.yml")

XERO_CONSUMER_KEY = ymlconf['xero']['consumer_key']
XERO_CONSUMER_SECRET = ymlconf['xero']['consumer_secret']
XERO_CALLBACK_URL = ymlconf['xero']['callback_url']

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address  => ymlconf['smtp']['address'],
  :port  => ymlconf['smtp']['port'],
  :domain => ymlconf['smtp']['domain']
  #,
  # :user_name => ymlconf['smtp']['user_name'],
  # :password => ymlconf['smtp']['password'],
  # :authentication => :login,
  # :ssl => true
}

ActionMailer::Base.perform_deliveries = false
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_charset = "iso-8859-1"
ActionMailer::Base.default_url_options[:host] = "nzffa.org.nz"
