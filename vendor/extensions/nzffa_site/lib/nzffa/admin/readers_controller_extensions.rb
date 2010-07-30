module Nzffa::Admin::ReadersControllerExtensions
  
  # def self.included base
  #   base.class_eval {
  #     
  #   }
  # end
  
  def search
    @readers = Reader.paginate(:page => params[:page], :order => 'readers.created_at desc')
  end
  
  
end
