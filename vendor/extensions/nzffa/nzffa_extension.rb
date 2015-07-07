# Uncomment this if you reference any of your controllers in activate
# require_dependency "application_controller"
# 
require 'reader_mixin'
#require 'reader_validator'
require "radiant-nzffa-extension"

class NzffaExtension < Radiant::Extension
  version     RadiantNzffaExtension::VERSION
  description RadiantNzffaExtension::DESCRIPTION
  url         RadiantNzffaExtension::URL

  # See your config/routes.rb file in this extension to define custom routes

  extension_config do |config|
    # config is the Radiant.configuration object
  end

  def activate
    Reader.send :include, ReaderMixin
    AccountsController.send :include, Marketplace::AccountsControllerExtension

    tab 'Readers' do
      add_item "Readers Plus", "/admin/readers_plus"
      add_item "Subscriptions", "/admin/subscriptions"
      add_item "Orders", "/admin/orders"
      add_item "Reports", "/admin/reports"
      add_item "Print Subscriptions", "/admin/subscriptions/batches_to_print"
    end

  end
end
