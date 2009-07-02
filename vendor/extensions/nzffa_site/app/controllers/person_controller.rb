class PersonsController < NzffaController
	
	def index
		@persons = Person.find(:all)
	end
	
  def new
    @person = Person.new
  end
  
  def create
    @person = Person.new(params[:person])
    if @person.save
      flash[:notice] = "Successfully created person."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @person = Person.find(params[:id])
  end
  
  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(params[:person])
      flash[:notice] = "Successfully updated person."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
end