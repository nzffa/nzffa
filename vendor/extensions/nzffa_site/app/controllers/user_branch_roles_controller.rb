class UserBranchRolesController < ApplicationController
  # GET /user_branch_roles
  # GET /user_branch_roles.xml
  def index
    @user_branch_roles = UserBranchRole.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_branch_roles }
    end
  end

  # GET /user_branch_roles/1
  # GET /user_branch_roles/1.xml
  def show
    @user_branch_role = UserBranchRole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_branch_role }
    end
  end

  # GET /user_branch_roles/new
  # GET /user_branch_roles/new.xml
  def new
    @user_branch_role = UserBranchRole.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_branch_role }
    end
  end

  # GET /user_branch_roles/1/edit
  def edit
    @user_branch_role = UserBranchRole.find(params[:id])
  end

  # POST /user_branch_roles
  # POST /user_branch_roles.xml
  def create
    @user_branch_role = UserBranchRole.new(params[:user_branch_role])

    respond_to do |format|
      if @user_branch_role.save
        flash[:notice] = 'UserBranchRole was successfully created.'
        format.html { redirect_to(@user_branch_role) }
        format.xml  { render :xml => @user_branch_role, :status => :created, :location => @user_branch_role }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_branch_role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_branch_roles/1
  # PUT /user_branch_roles/1.xml
  def update
    @user_branch_role = UserBranchRole.find(params[:id])

    respond_to do |format|
      if @user_branch_role.update_attributes(params[:user_branch_role])
        flash[:notice] = 'UserBranchRole was successfully updated.'
        format.html { redirect_to(@user_branch_role) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_branch_role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_branch_roles/1
  # DELETE /user_branch_roles/1.xml
  def destroy
    @user_branch_role = UserBranchRole.find(params[:id])
    @user_branch_role.destroy

    respond_to do |format|
      format.html { redirect_to(user_branch_roles_url) }
      format.xml  { head :ok }
    end
  end
end
