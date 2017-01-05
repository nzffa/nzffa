# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-page_parts-extension"

Gem::Specification.new do |s|
  s.name        = "radiant-page_parts-extension"
  s.version     = RadiantPagePartsExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = RadiantPagePartsExtension::AUTHORS
  s.email       = RadiantPagePartsExtension::EMAIL
  s.homepage    = RadiantPagePartsExtension::URL
  s.summary     = RadiantPagePartsExtension::SUMMARY
  s.description = RadiantPagePartsExtension::DESCRIPTION

  
  ignores = if File.exist?('.gitignore')
    File.read('.gitignore').split("\n").inject([]) {|a,p| a + Dir[p] }
  else
    []
  end
  s.files         = Dir['**/*'] - ignores
  s.test_files    = Dir['test/**/*','spec/**/*','features/**/*'] - ignores
  # s.executables   = Dir['bin/*'] - ignores
  s.require_paths = ["lib"]
  
  s.post_install_message = %{
  Add this to your radiant project with:
    config.gem 'radiant-translate-extension', :version => '~>#{RadiantPagePartsExtension::VERSION}'
  }
end