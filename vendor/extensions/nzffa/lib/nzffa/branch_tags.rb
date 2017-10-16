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
    options = group_find_options(tag)
    result = []
    tag.locals.branches.all(options).each do |branch|
      tag.locals.branch = branch
      result << tag.expand
    end
    result.join ''
  end
  
  desc %{
    Sets the branch scope the branch with the id specified in the id attribute.

    <pre><code><r:branch id="1">...</r:branch></code></pre>
  }
  tag "branch" do |tag|
    if id = tag.attr.delete('id')
      tag.expand if tag.locals.branch = Group.find(id)
    else
      tag.expand if tag.locals.branch
    end
  end
  
  desc %{
    Sets the group scope to the current branch.

    <pre><code><r:branch id="1"><r:group>...</r:group></r:branch></code></pre>
    
    or
    
    <pre><code><r:branches:each:group>...</r:branches:each:group></code></pre>
  }
  tag "branches:each:group" do |tag|
    tag.locals.group = tag.locals.branch
    tag.expand
  end
  tag "branch:group" do |tag|
    tag.locals.group = tag.locals.branch
    tag.expand
  end
  desc %{
    Sets the page scope to the current group's homepage.
    
    <pre><code><r:group:homepage>...</r:group:homepage></code></pre>
  }
  tag "group:homepage" do |tag|
    tag.locals.page = tag.locals.group.homepage
    tag.expand
  end
  
  %w(secretary president treasurer councillor newsletter_editor).each do |role|
    desc %{
      Sets the reader scope to the current branch's #{role}.
      The reader id of the #{role} is to be set in a page field '#{role}_reader_id' on the homepage of this branch
      <pre><code><r:branches:each:#{role}:reader>...</r:branches:each:#{role}:reader></code></pre>
    }
    tag "branches:each:#{role}" do |tag|
      id = tag.locals.branch.homepage.try(:field, role + '_reader_id')
      tag.expand if id && tag.locals.send("#{role}=", Reader.find(id))
    end
    tag "branch:#{role}" do |tag|
      id = tag.locals.branch.homepage.try(:field, role + '_reader_id')
      tag.expand if id && tag.locals.send("#{role}=", Reader.find(id))
    end
    tag "branches:each:#{role}:reader" do |tag|
      tag.locals.reader = tag.locals.send(role)
      tag.expand
    end
    tag "branch:#{role}:reader" do |tag|
      tag.locals.reader = tag.locals.send(role)
      tag.expand
    end
  
  end
  
  desc %{
    Renders a link to the branch_admin page of the current branch.
    You can set your own link text by using this as a double tag

    <pre><code><r:branches:each:admin_link>link text</r:branches:each:admin_link></code></pre>
  }
  tag "branches:each:admin_link" do |tag|
    # Can not do this because tag.double?
    # tag.render('branch:admin_link', tag.attr.dup)
    # So just duplicate code..:
    url = "/branch_admin/#{tag.locals.branch.id}"
    options = tag.attr.dup
    attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
    attributes = " #{attributes}" unless attributes.empty?
    text = tag.double? ? tag.expand : url
    %{<a href="#{url}"#{attributes}>#{text}</a>}
  end
  tag "branch:admin_link" do |tag|
    url = "/branch_admin/#{tag.locals.branch.id}"
    options = tag.attr.dup
    attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
    attributes = " #{attributes}" unless attributes.empty?
    text = tag.double? ? tag.expand : url
    %{<a href="#{url}"#{attributes}>#{text}</a>}
  end

  def group_find_options tag
    attr = tag.attr.symbolize_keys
    options = {}
    
    by = (attr[:by] || 'name').strip
    order = (attr[:order] || 'asc').strip
    order_string = ''
    if Group.new.attributes.keys.include?(by)
      order_string << by
    else
      raise TagError.new("`by' attribute of `each' tag must be set to a valid field name")
    end
    if order =~ /^(asc|desc)$/i
      order_string << " #{$1.upcase}"
    else
      raise TagError.new(%{`order' attribute of `each' tag must be set to either "asc" or "desc"})
    end
    options[:order] = order_string
    options
  end
end
