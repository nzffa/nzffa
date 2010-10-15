module Nzffa::Admin::ReadersControllerExtensions
  
  def self.included base
    base.class_eval {
      skip_before_filter :load_models
    }
  end
  
  def index
    search_string = "%#{params[:q]}%"
    # @readers = Reader.find(:all, :order => 'readers.created_at desc', :conditions => ["first_name LIKE ? OR last_name LIKE ?", search_string, search_string], :include => :groups )
    
    @readers = Reader.paginate(:page => params[:page], :per_page => 50, :order => 'readers.created_at desc', :include => :groups, :conditions => ["first_name LIKE ? OR last_name LIKE ?", search_string, search_string])
  end
  
  
end
