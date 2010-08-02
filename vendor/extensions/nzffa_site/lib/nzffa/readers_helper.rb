module Nzffa::ReadersHelper
  def self.included(base)
    base.class_eval {
        def pretty_groups groups
          [groups].flatten.inject([]) { |array, group|
            array << group_tag(group)
          }.join(" ")
        end
        
        def pretty_group_links groups
          [groups].flatten.inject([]) { |array, group|
            array << link_to(group_tag(group), admin_group_path(group), :class => "group_link")
          }.join(" ")
        end
        
        def group_tag group
          content_tag(:span, group.name, :class => "group_tag #{group.name.parameterize}")
        end

        def css_for_readers_groups readers
          # this should handle either a single reader, or an array being passed in:
          groups = [readers].flatten.map(&:groups).flatten

          css = groups.map { |group|
            group_name = group.name.parameterize #should take care of dumb inputs for us
            hue = ((Math.sin(group.id*431.26570001)+1)/2)*20000 % 360
            colour = Color::HSL.new(hue, 50, 68).html
            hover_colour = Color::HSL.new(hue, 50, 85).html
            ".group_tag.#{group_name} { background-color: #{colour}; } \na:hover .group_tag.#{group_name} { background-color: #{hover_colour}; }"
          }.join("\n")

          css << "
a.group_link {
  text-decoration: none;
}
.group_tag {
	padding: 2px 12px;
	border-radius: 3px;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	-o-border-radius: 3px;
	margin-left: 2px;
	font: 13px/27px Geneva, 'Helvetica Neue', Arial, Helvetica, sans-serif;
	color: #2d2d2d;
	white-space: nowrap;
}
          "
        end
    }
  end

end
