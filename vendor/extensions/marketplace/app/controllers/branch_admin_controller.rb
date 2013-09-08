class BranchAdminController < MarketplaceController
  before_filter :require_current_reader
  before_filter :require_branch_secretary
  radiant_layout "no_layout"

  def index
    @group = Group.find(params[:group_id])
    @readers = @group.readers
  end

  def email
    @group = Group.find(params[:group_id])

    @group_readers = @group.readers
    @readers = Reader.find(:all,
                       :conditions => ['(email not like "%@nzffa.org.nz") AND
                                       readers.id IN (?)', @group_readers.map(&:id)])
  end

  def edit
    @reader = Reader.find_by_nzffa_membership_id(params[:nzffa_membership_id])
  end

  def update
    @reader = Reader.find_by_nzffa_membership_id(params[:nzffa_membership_id])
    @reader.attributes = params[:reader]
    if @reader.save(false)
      flash[:notice] = 'Updated member'
      redirect_to branch_admin_path(params[:group_id])
    else
      render :edit
    end
  end


  def require_branch_secretary
    @group = Group.find(params[:group_id])
    unless current_reader.is_secretary? and current_reader.groups.include? @group
      flash[:error] = 'You are not a group member or you are not a secretary'
      redirect_to root_path
    end
  end
end
