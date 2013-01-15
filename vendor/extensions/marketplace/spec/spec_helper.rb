unless defined? RADIANT_ROOT
  ENV["RAILS_ENV"] = "test"
  case
  when ENV["RADIANT_ENV_FILE"]
    require ENV["RADIANT_ENV_FILE"]
  when File.dirname(__FILE__) =~ %r{vendor/radiant/vendor/extensions}
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../../../")}/config/environment"
  else
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../")}/config/environment"
  end
end

# This is a nasty hack to trick radiant into loading some file other than it's own config again
ENV["RADIANT_ENV_FILE"] = 'uri'
require "#{RADIANT_ROOT}/spec/spec_helper"
ENV["RADIANT_ENV_FILE"] = nil

#Dataset::Resolver.default << (File.dirname(__FILE__) + "/datasets")

if File.directory?(File.dirname(__FILE__) + "/matchers")
  Dir[File.dirname(__FILE__) + "/matchers/*.rb"].each {|file| require file }
end

Spec::Runner.configure do |config|
  # config.use_transactional_fixtures = true
  # config.use_instantiated_fixtures  = false
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures'

  # You can declare fixtures for each behaviour like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so here, like so ...
  #
  #   config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
end

def create_admin_user
  User.create!(:name => 'charles admin',
              :email => 'cmoney@admin.com',
              :login => 'cmoneyhoney',
              :password => 'password',
              :password_confirmation => 'password',
              :admin => true)
end
