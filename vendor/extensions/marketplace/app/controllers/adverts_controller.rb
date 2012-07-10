class AdvertsController < SiteController
  MY_ADVERTS_URL = '/specialty-timber-market/marketplace/my-adverts/'

  radiant_layout "ffm_specialty_timbers"
  before_filter :load_company_listing, :only => [:my_adverts, :edit_company_listing]
  before_filter :load_advert, :only => [:edit, :update, :destroy, :renew, :email]
  before_filter :require_current_reader, :only => [:my_adverts, :new, :create, :edit, :update, :edit_company_listing, :renew]
  before_filter :require_fft_group, :only => [:my_adverts, :new, :create, :edit, :update, :edit_company_listing, :renew]
  before_filter :require_no_current_reader, :only => [:newsletter_signup, :signup]

  def newsletter_signup
    if params[:reader]
      @reader = Reader.new(params[:reader])
      @reader.password = ('a'..'z').to_a.sample(8)
      if @reader.save
        @reader.groups << Group.find(230)
        flash[:notice] = 'Signed up to the Newsletter successfully'
        redirect_to '/specialty-timber-market/marketplace/'
      end
    else
      @reader = Reader.new
    end
    render :layout => false if request.xhr?
  end

  #timber market signup
  def signup
    if params[:advert]
      @company_listing = Advert.new(params[:advert])
      if @company_listing.save
        @reader = @company_listing.reader
        @reader.groups << Group.find(100)
        @reader.groups << Group.find(229)
        flash[:notice] = 'Signed up successfully'
        redirect_to '/specialty-timber-market/participate/membership/'
      end
    else
      @company_listing = Advert.new(:is_company_listing => true)
      @company_listing.reader = Reader.new
    end
    render :layout => false if request.xhr?
  end

  def edit_company_listing
    render :layout => false if request.xhr?
  end

  def new
    @advert = Advert.new
    render :layout => false if request.xhr?
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

  def renew
    @advert.update_attribute(:expires_on, 1.month.from_now)
    flash[:notice] = "Advert will expire on #{@advert.expires_on}"
    redirect_to MY_ADVERTS_URL
  end

  def update
    if @advert.update_attributes(params[:advert])
      flash[:notice] = 'Advert was successfully updated.'
      redirect_to MY_ADVERTS_URL
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
      redirect_to MY_ADVERTS_URL
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
    redirect_to MY_ADVERTS_URL
  end

  def email
    ExpiryMailer.deliver_warning_email(@advert)
    render :text => 'sent email'
  end


  protected


  def load_company_listing
    return unless current_reader
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

    unless params[:query].blank?
      fields = %w[categories
                  title
                  body
                  supplier_of
                  buyer_of
                  services
                  readers.website
                  timber_for_sale
                  timber_species
                  business_description
                  readers.organisation
                  readers.name
                  readers.description
                  readers.physical_address
                  readers.post_line1
                  readers.post_line2
                  readers.region]
      terms = params[:query].split(' ')

      query = terms.map{ |term| fields.map { |field| "#{field} LIKE ?" }.join(" OR ")}.join(") AND (")
      query = "("+query+")"
      values = terms.map{ |term| ["%#{term}%"] * fields.size }.flatten


      find_options[:conditions] = [query, *values]
    end

    find_options[:joins] = :reader

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

  def require_no_current_reader
    if current_reader
      flash[:error] = 'Sorry, these actions are for creating new accounts'
      redirect_to '/account/'
    end
  end

  def require_fft_group
    unless current_reader.group_ids.include? 229
      flash[:error] = 'Sorry, but you must belong to Farm Forestry Timbers Group'
      redirect_to root_path
    end
  end

end
