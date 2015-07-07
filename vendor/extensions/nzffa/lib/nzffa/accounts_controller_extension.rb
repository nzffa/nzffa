module Nzffa::AccountsControllerExtension
  
  def self.included(klass)
    klass.class_eval do
      def create_with_secretary_access
        if current_reader && current_reader.is_secretary?
          @reader = Reader.new(params[:reader])
          @reader.clear_password = params[:reader][:password]

          if (@reader.valid?)
            @reader.activated_at = DateTime.now
            @reader.save!
            flash[:notice] = "Registration of #{@reader.name} was succesful."
            redirect_to '/account'
          else
            @reader.email_field = session[:email_field]
            render :action => 'new'
          end
        else
          create_without_secretary_access
        end
      end
      alias_method_chain :create, :secretary_access      
    end
  end
end