class AdvertsController < ApplicationController
  radiant_layout "for_rails"
  before_filter :load_own_advert, :only => [:edit, :update, :destroy]

  def edit_company_listing
    @advert = Advert.find(:first, :conditions => {:is_company_listing => true, :reader_id => current_reader.id})
    unless @advert
      @advert = Advert.new
    end
  end

  def new
    @advert = Advert.new
  end

  def index
    @adverts = Advert.paginate(:all, index_params)

    if request.xhr?
      render :partial => 'table', :layout => false
    end

  end

  def show
    @advert = Advert.find_by_id(params[:id])
  end

  def edit
  end

  def create
    @advert = current_reader.adverts.build(params[:advert])
    if @advert.save
      flash[:notice] = 'Advert was successfully created.'
      redirect_to @advert
    else
      render :action => "new"
    end
  end

  def update
    if @advert.update_attributes(params[:advert])
      flash[:notice] = 'Advert was successfully updated.'
      redirect_to @advert
    else
      render :action => "edit"
    end
  end

  def destroy
    @advert.destroy
    redirect_to(adverts_url)
  end


  protected

  def load_own_advert
    @advert = Advert.find(:all, :conditions => {:id => params[:id], :reader_id => current_reader.id})
  end

  def index_params
    find_options = {}
    find_options[:page] = params[:page]
    find_options[:per_page] = 8

    unless params[:query].nil?
      fields = %w[category location title body]
      like_string = fields.map { |field| "#{field} LIKE ?" }.join(" OR ")
      array_of_search_term = fields.map { |field| "%#{params[:query]}%" }

      find_options[:conditions] = [like_string, *array_of_search_term]
    end

    order_options = { 'title'          => 'title DESC',
                      'price'          => 'price DESC',
                      'date'           => 'created_at DESC',
                      'title_reversed' => 'title ASC',
                      'price_reversed' => 'price ASC',
                      'date_reversed'  => 'created_at ASC' }

    if order_options[params[:sort]]
      find_options[:order] = order_options[params[:sort]]
    end
    find_options
  end
end
