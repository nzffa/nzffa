module Nzffa::ChildWithCorrespondingSlugTag
  include Radiant::Taggable

  desc %{
    Sets the page scope to the child page that has the same slug as the page being rendered.
    E.g. on /fruits/apples you can set the scope to /healthy-foods/apples like this:

    <pre><code><r:find path="healthy-foods"><r:child_with_corresponding_slug>...</r:child_with_corresponding_slug></r:find></code></pre>
  }
  tag "child_with_corresponding_slug" do |tag|
    tag.locals.page = tag.locals.page.children.find_by_slug tag.globals.page.slug
    tag.expand
  end

end
