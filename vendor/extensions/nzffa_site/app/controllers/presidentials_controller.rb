class PresidentialsController < NzffaController
  # GET /presidentials
  # GET /presidentials.xml
  def index
    @presidentials = Presidential.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @presidentials }
    end
  end

  # GET /presidentials/1
  # GET /presidentials/1.xml
  def show
    @presidential = Presidential.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @presidential }
    end
  end

  # GET /presidentials/new
  # GET /presidentials/new.xml
  def new
    @presidential = Presidential.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @presidential }
    end
  end

  # GET /presidentials/1/edit
  def edit
    @presidential = Presidential.find(params[:id])
  end

  # POST /presidentials
  # POST /presidentials.xml
  def create
    @presidential = Presidential.new(params[:presidential])

    respond_to do |format|
      if @presidential.save
        flash[:notice] = 'Presidential was successfully created.'
        format.html { redirect_to(@presidential) }
        format.xml  { render :xml => @presidential, :status => :created, :location => @presidential }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @presidential.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /presidentials/1
  # PUT /presidentials/1.xml
  def update
    @presidential = Presidential.find(params[:id])

    respond_to do |format|
      if @presidential.update_attributes(params[:presidential])
        flash[:notice] = 'Presidential was successfully updated.'
        format.html { redirect_to(@presidential) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @presidential.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /presidentials/1
  # DELETE /presidentials/1.xml
  def destroy
    @presidential = Presidential.find(params[:id])
    @presidential.destroy

    respond_to do |format|
      format.html { redirect_to(presidentials_url) }
      format.xml  { head :ok }
    end
  end
end
