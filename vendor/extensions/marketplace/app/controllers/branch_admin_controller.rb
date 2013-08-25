class BranchAdminController < MarketplaceController
  before_filter :require_current_reader
  before_filter :require_branch_secretary
  before_filter :load_group_and_readers, :only => [:index, :email]
  radiant_layout "no_layout"

  def index
  end

  def email
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

  private
  def load_group_and_readers
    @group = Group.find(params[:group_id])

    @group_readers = @group.readers.where('id in (?)',
                                          @allowed_readers.map(&:id))
    @readers = Reader.find(:all,
                       :conditions => ['(email not like "%@nzffa.org.nz") AND
                                       readers.id IN (?)', @group_readers.map(&:id)])
  end

  def require_branch_secretary
    @group = Group.find(params[:group_id])
    unless current_reader.is_secretary? and current_reader.groups.include? @group
      flash[:error] = 'You are not a group member or you are not a secretary'
      redirect_to root_path
    end
  end
end
