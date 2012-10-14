class Admin::AdvertsController < ApplicationController
  before_filter :load_advert, :only => [:show, :edit, :update, :destroy]
  helper :adverts

  def index
    @adverts = Advert.all
  end

  def new
    @advert = Advert.new
  end

  def show
  end

  def edit
  end

  def update
    @advert.update_attributes params[:advert]
    if @advert.valid?
      redirect_to [:admin, :adverts], :notice => 'Updated advert'
    else
      render :edit
    end
  end

  def create
    @advert = Advert.create(params[:advert])
    if @advert.valid?
      redirect_to [:admin, :adverts], :notice => 'Advert created'
    else
      render :new
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
