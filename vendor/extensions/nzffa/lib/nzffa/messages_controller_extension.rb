module Nzffa::MessagesControllerExtension
  def self.included(klass)
    klass.class_eval do  
      def deliver_with_nzffa
        @readers = []
        if params['delivery'] == 'selected_groups_wo_disallowed_renewal_mails'
          load_selected_groups
          load_readers_for_groups
          @readers = @readers.reject{|r| r.disallow_renewal_mails }
      
          failures = @message.deliver(@readers) || []
          if failures.length == @readers.length
            flash[:error] = t("reader_extension.all_deliveries_failed")
          else
            if failures.any?
              addresses = failures.map(&:email).to_sentence
              flash[:notice] = t("reader_extension.some_deliveries_failed")
            else
              flash[:notice] = t("reader_extension.message_delivered")
            end
            @message.update_attribute :sent_at, Time.now
          end
          redirect_to admin_message_url(@message)
        else
          deliver_without_nzffa
        end
      end

      alias_method_chain :deliver, :nzffa
    end
  end
end