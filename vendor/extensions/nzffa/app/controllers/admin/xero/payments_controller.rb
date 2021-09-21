class Admin::Xero::PaymentsController < Admin::ResourceController
  def model_class
    XeroSync
  end

  def new
    XeroSync.create
    redirect_to :action => :index
  end

  def show
    @xero_sync = XeroSync.find(params[:id])
  end
end
