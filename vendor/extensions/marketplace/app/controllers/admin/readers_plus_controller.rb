class Admin::ReadersPlusController < AdminController
  def index
    @readers = Reader.all
  end

  def edit
    @reader = Reader.find params[:id]
  end

  def update
    @reader = Reader.find params[:id]
    if @reader.update_attributes(params[:reader])
      flash[:notice] = 'Updated reader'
      redirect_to [:admin, :readers_plus]
    else
      render :edit
    end
  end
end
