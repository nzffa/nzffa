module Nzffa::Admin::ReadersControllerExtensions
  
  # def self.included base
  #   base.class_eval {
  #     
  #   }
  # end
  
  def search
    search_string = "%#{params[:q]}%"
    @readers = Reader.find(:all, :order => 'readers.created_at desc', :conditions => ["first_name LIKE ? OR last_name LIKE ?", search_string, search_string] )
    
    # @readers = Reader.paginate(:page => params[:page], :order => 'readers.created_at desc',
    #                            :conditions => ["first_name LIKE ? OR last_name LIKE ?", search_string, search_string])
  end
  
  
end
