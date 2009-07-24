class AdvertsController < NzffaController
  radiant_layout "for_rails"
  before_filter :require_authorization, :only => [:edit, :update, :destroy] 
  
  def index
    find_options = {}
    find_options[:page] = params[:page]
    find_options[:per_page] = 8
    
    unless params[:query].nil?
      fields = %w[ad_type location title body]
      like_string = fields.map { |field| "#{field} LIKE ?" }.join(" OR ")
      array_of_search_term = fields.map { |field| "%#{params[:query]}%" }
      
      find_options[:conditions] = [like_string, *array_of_search_term]
    end
    
    order_options = { "title"=>"title DESC",
      "price"=>"price DESC",
      "date" =>"created_at DESC",
      "title_reversed"=>"title ASC",
      "price_reversed"=>"price ASC",
      "date_reversed" =>"created_at ASC" }
      
    if order_options[params[:sort]]
      find_options[:order] = order_options[params[:sort]]
    end
    
    # @advertsa = Advert.active
    @adverts = Advert.active.paginate(:all, find_options)
    respond_to do |format|
      format.html # index.html.erb
      format.js { render :partial => "adverts_list", :layout => false }
    end
  end


  def show
    @advert = Advert.find(params[:id])
  end


  def new
    @advert = Advert.new
    @person = Person.new
  end


  def edit
    @advert = Advert.find(params[:id])
  end


  def create
    @advert = Advert.new(params[:advert])
    @advert.status = true
    
    @advert.person = if current_person
      current_person
    else
      @person = Person.new(params[:person])
      @person.adverts << @advert
      @person
    end
    
    if (current_person || @person.save) && @advert.save
      flash[:notice] = 'Advert was successfully created.'
      # BackOfficeMailer.deliver_advert_confirmation(@advert)
      redirect_to(@advert)
    else
      render :action => "new"
    end
  end


  def update
    @advert = Advert.find(params[:id])

    if @advert.update_attributes(params[:advert])
      flash[:notice] = 'Advert was successfully updated.'
      redirect_to(@advert)
    else
      render :action => "edit"
    end
  end


  def destroy
    @advert = Advert.find(params[:id])
    @advert.destroy

    redirect_to(adverts_url)
  end
  
  private
  
  def require_authorization
    unless authorized_for? Advert.find(params[:id])
      flash[:error] = "Naughty naughty."
      redirect_to adverts_url
    end
  end
  
end
