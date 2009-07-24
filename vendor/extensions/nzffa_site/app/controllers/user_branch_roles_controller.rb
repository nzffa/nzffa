class PersonBranchRolesController < ApplicationController
  # GET /person_branch_roles
  # GET /person_branch_roles.xml
  def index
    @person_branch_roles = PersonBranchRole.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @person_branch_roles }
    end
  end

  # GET /person_branch_roles/1
  # GET /person_branch_roles/1.xml
  def show
    @person_branch_role = PersonBranchRole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person_branch_role }
    end
  end

  # GET /person_branch_roles/new
  # GET /person_branch_roles/new.xml
  def new
    @person_branch_role = PersonBranchRole.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person_branch_role }
    end
  end

  # GET /person_branch_roles/1/edit
  def edit
    @person_branch_role = PersonBranchRole.find(params[:id])
  end

  # POST /person_branch_roles
  # POST /person_branch_roles.xml
  def create
    @person_branch_role = PersonBranchRole.new(params[:person_branch_role])

    respond_to do |format|
      if @person_branch_role.save
        flash[:notice] = 'PersonBranchRole was successfully created.'
        format.html { redirect_to(@person_branch_role) }
        format.xml  { render :xml => @person_branch_role, :status => :created, :location => @person_branch_role }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person_branch_role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /person_branch_roles/1
  # PUT /person_branch_roles/1.xml
  def update
    @person_branch_role = PersonBranchRole.find(params[:id])

    respond_to do |format|
      if @person_branch_role.update_attributes(params[:person_branch_role])
        flash[:notice] = 'PersonBranchRole was successfully updated.'
        format.html { redirect_to(@person_branch_role) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person_branch_role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /person_branch_roles/1
  # DELETE /person_branch_roles/1.xml
  def destroy
    @person_branch_role = PersonBranchRole.find(params[:id])
    @person_branch_role.destroy

    respond_to do |format|
      format.html { redirect_to(person_branch_roles_url) }
      format.xml  { head :ok }
    end
  end
end
