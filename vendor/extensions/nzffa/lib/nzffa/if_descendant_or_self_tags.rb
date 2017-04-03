module Nzffa::IfDescendantOrSelfTags
  include Radiant::Taggable
  
  class TagError < StandardError; end

  desc %{
    Renders the contained elements if the current contextual page is either the actual page or one of its descendants.

    This is typically used inside another tag (like &lt;r:children:each&gt;) to add conditional mark-up if the child element is (an ancestor of) the current page.

    *Usage:*
    
    <pre><code><r:if_descendant_or_self>...</r:if_descendant_or_self></code></pre>
  }
  tag "if_descendant_or_self" do |tag|
    # expand if the path of the page in scope starts with or is equal to the path of the page being rendered
    tag.expand if tag.locals.page.path.index(tag.globals.page.path) == 0
  end

  desc %{
    Renders the contained elements unless the current contextual page is either the actual page or one of its descendants.

    This is typically used inside another tag (like &lt;r:children:each&gt;) to add conditional mark-up if the child element is not the current page nor one of it's ancestors.

    *Usage:*
    
    <pre><code><r:unless_descendant_or_self>...</r:unless_descendant_or_self></code></pre>
  }
  tag "unless_descendant_or_self" do |tag|
    tag.expand unless tag.locals.page.path.index(tag.globals.page.path) == 0
  end
end
