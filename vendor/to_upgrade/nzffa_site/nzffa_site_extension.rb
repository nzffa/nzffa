require_dependency 'application_controller'

class NzffaSiteExtension < Radiant::Extension
  version "1.0"
  description "Home for all NZFFA specific alterations, both frontend and admin side. Has adverts, members tracking through reader extension."
  url "http://gunn.co.nz"

  extension_config do |config|
    config.gem 'color'
    config.gem 'inherited_resources', :version => "1.0.6"
  end

  def activate
    Admin::ReadersController.send :include, Nzffa::Admin::ReadersControllerExtensions

    Reader.send :include, Nzffa::ReaderExtensions
    User.send :include, Nzffa::UserExtensions
  end

end
