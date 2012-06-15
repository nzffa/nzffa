class Admin::AdvertsController < ApplicationController
  before_filter :load_advert, :only => [:show, :edit, :update, :destroy]
  helper :adverts

  def index
    @adverts = Advert.all
  end

  def show
  end

  def edit
  end

  def update
    @advert.update_attributes params[:advert]
    if @advert.valid?
      redirect_to [:admin, @advert], :notice => 'Updated advert'
    else
      render :edit
    end
  end

  def destroy
    @advert.destroy
  redirect_to [:admin, :adverts], :notice => 'Destroyed advert'
  end

  protected
  def load_advert
    @advert = Advert.find(params[:id])
  end
end
