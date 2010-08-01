module Nzffa::ReadersHelper
  def self.included(base)
    base.class_eval {
        def pretty_groups groups
          [groups].flatten.inject("") do |styled_string, group|
            styled_string << content_tag(:span, group.name, :class => "group_tag #{group.name.parameterize}")+" "
          end
        end

        def css_for_readers_groups readers
          # this should handle either a single reader, or an array being passed in:
          groups = [readers].flatten.map(&:groups).flatten

          css = groups.map { |group|
            group_name = group.name.parameterize #should take care of dumb inputs for us
            hue = ((Math.sin(group.id*431.26570001)+1)/2)*20000 % 360
            colour = Color::HSL.new(hue, 50, 60).html
            hover_colour = Color::HSL.new(hue, 50, 80).html
            ".group_tag.#{group_name} { background-color: #{colour}; } \n.group_tag:hover.#{group_name} { background-color: #{hover_colour}; }"
          }.join("\n")

          css << "
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
