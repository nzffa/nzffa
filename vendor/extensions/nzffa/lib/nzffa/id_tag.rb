module Nzffa::IdTag
  include Radiant::Taggable
  
  class TagError < StandardError; end
  
  desc "Renders the id of the current page"
  
  tag "id" do |tag|
    tag.locals.page.id
  end
  
end
