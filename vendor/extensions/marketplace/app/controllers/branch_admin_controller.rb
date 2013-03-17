class BranchAdminController < SiteController
  before_filter :require_branch_secretary

  def index
    @branch = Branch.find(params[:branch_id])
    @group = Group.find(@branch.group_id)
    @readers = @group.readers
  end

  def edit
    @reader = Reader.find_by_nzffa_membership_id(params[:nzffa_membership_id])
  end

  def update
    @reader = Reader.find_by_nzffa_membership_id(params[:nzffa_membership_id])
    @reader.attributes = params[:reader]
    if @reader.save(false)
      flash[:notice] = 'Updated member'
      redirect_to branch_admin_path(params[:branch_id])
    else
      render :edit
    end
  end

  private
  def require_branch_secretary
    @branch = Branch.find(params[:branch_id])
    unless current_reader.is_secretary? and current_reader.group_ids.include? @branch.group_id
      flash[:error] = 'You are not a branch secretary'
      redirect_to root_path
    end
  end
end
