# Uncomment this if you reference any of your controllers in activate
# require_dependency "application_controller"
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
    # tab 'Content' do
    #   add_item "Nzffa", "/admin/nzffa", :after => "Pages"
    # end
  end
end
