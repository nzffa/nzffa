module PageParts
  module PageExtensions
    def self.included(base)
      base.class_eval do
        # Recast everything to base class so it's all transparent to the parser
        def parse_object(object)
          object = object.becomes(PagePart) if object.class < PagePart
          text = object.content || ''
          text = parse(text)
          text = object.filter.filter(text) if object.respond_to? :filter_id
          text
        end
        # alias_method_chain :parse_object, :page_part_subclasses
      end
    end
  end
end