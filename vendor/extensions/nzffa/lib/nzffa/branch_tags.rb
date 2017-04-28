module Nzffa::BranchTags
  include Radiant::Taggable
  
  class TagError < StandardError; end

  tag "branches" do |tag|
    tag.locals.branches = Group.branches
    tag.expand
  end
  
  desc %{
    Iterates over all the branches

    <pre><code><r:branches:each:group>...</r:branches:each:group /></code></pre>
  }
  tag "branches:each" do |tag|
    result = []
    tag.locals.branches.each do |branch|
      tag.locals.branch = branch
      result << tag.expand
    end
    result.join ''
  end
  
  tag "branches:each:group" do |tag|
    tag.locals.group = tag.locals.branch
    tag.expand
  end
  
  tag "branches:each:group:homepage" do |tag|
    tag.locals.page = tag.locals.group.homepage
    tag.expand
  end
  
  desc %{
    Sets the reader scope to the current branch's secretary.
    The reader id of the secretary is to be set in a page field 'secretary_reader_id' on the homepage of this branch

    <pre><code><r:branches:each:secretary:reader>...</r:branch:secretary:reader /></code></pre>
  }
  tag "branches:each:secretary" do |tag|
    id = tag.locals.branch.homepage.try(:field, 'secretary_reader_id')
    tag.expand if tag.locals.secretary = Reader.find(id)
  end
  
  tag "branches:each:secretary:reader" do |tag|
    tag.locals.reader = tag.locals.secretary
    tag.expand
  end
  
  tag "branches:each:admin_link" do |tag|
    url = "/branch_admin/#{tag.locals.branch.id}"
    options = tag.attr.dup
    attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
    attributes = " #{attributes}" unless attributes.empty?
    text = tag.double? ? tag.expand : url
    %{<a href="#{url}"#{attributes}>#{text}</a>}
  end
end
