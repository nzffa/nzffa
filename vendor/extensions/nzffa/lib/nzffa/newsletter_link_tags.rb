module Nzffa::NewsletterLinkTags
  include Radiant::Taggable
  
  class TagError < StandardError; end
  
  desc "Looks for and rewrites relative links so they work in newsletters. The website host is looked up in Radiant::Config['site.host'].
  
  Usage: <r:absolutize_relative_links>Your newsletter contents ...</r:absolutize_relative_links>"
  tag "absolutize_relative_links" do |tag|
    output = tag.expand
    host = "http://#{Radiant::Config['site.host'].gsub(/http(s?):\/\//,'')}"
    output.gsub(/href=('|")([^(http:|mailto:|#)].*?)('|")/, 'href="' + host + '\2"').gsub(/src=('|")([^http:].*?)('|")/, 'src="' + host + '\2"')
  end
  
end
