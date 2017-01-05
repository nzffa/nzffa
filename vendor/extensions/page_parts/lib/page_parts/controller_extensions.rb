module PageParts::ControllerExtensions
  def self.included(base)
    base.class_eval do
      def model_name
        model_class.base_class.name
      end
      def model_class_with_page_parts
        @model_class ||= begin
          if params[:page_part][:page_part_type] && (klass = params[:page_part][:page_part_type].constantize) <= model_class_without_page_parts
            klass
          else
            model_class_without_page_parts
          end
        rescue NameError => e
          logger.warn "Wrong PagePart class given in PageParts#create: #{e.message}"
          model_class_without_page_parts
        end
      end
      alias_method_chain :model_class, :page_parts
    end
  end
end