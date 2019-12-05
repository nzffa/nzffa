class Admin::XeroSyncsController < Admin::ResourceController
  def new
    XeroSync.create
    redirect_to :action => :index
  end

  def show
    @xero_sync = XeroSync.find(params[:id])
  end
end
