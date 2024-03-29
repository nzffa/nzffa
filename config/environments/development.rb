# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes     = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils        = true

# Show full error reports and caching is turned off
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

ActionMailer::Base.perform_deliveries = false
config.action_mailer.raise_delivery_errors = false
ActionMailer::Base.default_charset = "iso-8859-1"
ActionMailer::Base.default_url_options[:host] = "localhost:3000"

ymlconf = YAML.load_file("#{Rails.root}/config/application.yml")
XERO_CONSUMER_KEY = ymlconf['xero']['consumer_key']
XERO_CONSUMER_SECRET = ymlconf['xero']['consumer_secret']
XERO_CALLBACK_URL = ymlconf['xero']['callback_url']
