# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title text
    "<h2>#{text}</h2>"
  end
  
  def make_pretty string
    string.gsub("\n", "<br/>")
  end
  
  
end
