class AdvertsController < SiteController
  radiant_layout "for_rails"
  before_filter :load_company_listing, :only => [:my_adverts, :edit_company_listing]
  before_filter :load_advert, :only => [:edit, :update, :destroy]
  before_filter :require_current_reader, :except => [:index, :show, :index_table]

  def edit_company_listing
  end

  def new
    @advert = Advert.new
  end

  def index
    @adverts = Advert.paginate(:all, index_params)
    render :layout => false if request.xhr?
  end

  def my_adverts
    @adverts = Advert.find(:all, :conditions => {:is_company_listing => false, :reader_id => current_reader.id})
    render :layout => false if request.xhr?
  end

  def index_table
    @adverts = Advert.paginate(:all, index_params)
    render :partial => 'table', :layout => false
  end

  def show
    @advert = Advert.find_by_id(params[:id])
    render :layout => false if request.xhr?
  end

  def edit
  end

  def renew_advert
  end

  def update
    if @advert.update_attributes(params[:advert])
      flash[:notice] = 'Advert was successfully updated.'
      redirect_to @advert
    else
      render :action => "edit"
    end
  end

  def create
    params[:advert][:reader_id]=current_reader.id
    @advert = Advert.new(params[:advert])
    @advert.expires_on = 1.month.from_now unless @advert.is_company_listing?
    if @advert.save
      flash[:notice] = 'Advert was successfully created.'
      redirect_to @advert
    else
      if @advert.is_company_listing?
        render :action => 'edit_company_listing'
      else
        render :action => "new"
      end
    end
  end

  def destroy
    @advert.destroy
    redirect_to(my_adverts_adverts_path)
  end


  protected


  def load_company_listing
    @company_listing = Advert.find(:first, :conditions => {:is_company_listing => true, :reader_id => current_reader.id})
    if @company_listing.nil?
      @company_listing = Advert.new(:is_company_listing => true, :reader => current_reader)
    end
  end

  def load_advert
    @advert = Advert.find params[:id], :conditions => {:reader_id => current_reader.id}
  end

  def index_params
    find_options = {}
    if params[:page] and params[:page].to_i > 0
      find_options[:page] = params[:page]
    else
      find_options[:page] = 1
    end
    find_options[:per_page] = 8

    unless params[:query].nil?
      fields = %w[categories location title body]
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

  def require_current_reader
    unless current_reader
      flash[:error] = 'Sorry, but you must be logged in to do this'
      redirect_to root_path
    end
  end
end
