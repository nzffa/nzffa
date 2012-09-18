# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger        = SyslogLogger.new


# Full error reports are disabled and caching is on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_controller.session_store = :active_record_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false

# Cache your content for a longer time, the default is 5.minutes
# config.after_initialize do
#   SiteController.cache_timeout = 12.hours
# end

ActionMailer::Base.delivery_method = :sendmail
ActionMailer::Base.sendmail_settings = {
  :location => '/usr/sbin/sendmail',
  :arguments => '-i -t'
}
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_charset = "iso-8859-1"
ActionMailer::Base.default_url_options[:host] = "nzffa.org.nz"
