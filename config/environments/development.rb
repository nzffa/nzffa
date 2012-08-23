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

PxPayParty.setup({:success_url => 'http://good.com',
                  :fail_url => 'http://bad.com',
                  :px_pay_user_id => 'NZFFA_dev',
                  :px_pay_key => '0edb744f3d87e729ae22dc66dcdd7db8bc52ac5dbcb6ca613ef99d457481ad35'})
