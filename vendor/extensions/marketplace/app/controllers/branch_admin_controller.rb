class BranchAdminController < MarketplaceController
  before_filter :require_current_reader
  before_filter :require_branch_secretary
  radiant_layout "no_layout"

  def index
    @group = Group.find(params[:group_id])
    @readers = @group.readers
  end

  def members_csv
    @group = Group.find(params[:group_id])
    @readers = @group.readers
    render_csv_of_readers
  end

  def past_members_csv
    @group = Group.find(params[:group_id])
    @branch = Branch.find(:first, :conditions => {:group_id => @group.id})

    subscription_branches = SubscriptionsBranch.find(:all, :conditions => {:branch_id => @branch.id})
    subscription_ids = subscription_branches.map(&:subscription_id)
    subscriptions = Subscription.find(:all, :conditions => {:id => subscription_ids})

    all_reader_ids = subscriptions.map(&:reader_id)
    current_reader_ids = @group.reader_ids

    @readers = Reader.find(all_reader_ids - current_reader_ids)

    render_csv_of_readers
  end

  def last_year_members_csv
    @group = Group.find(params[:group_id])
    @branch = Branch.find(:first, :conditions => {:group_id => @group.id})

    start_of_last_year = 1.year.ago.at_beginning_of_year
    end_of_last_year= 1.year.ago.at_end_of_year
    subscription_branches = SubscriptionsBranch.find(:all, :joins => :subscription, :conditions => ['branch_id = ? and (subscriptions.begins_on > ? and subscriptions.expires_on < ?)', @branch.id, start_of_last_year, end_of_last_year])
    subscription_ids = subscription_branches.map(&:subscription_id)
    subscriptions = Subscription.find(:all, :conditions => {:id => subscription_ids})

    all_reader_ids = subscriptions.map(&:reader_id)
    current_reader_ids = @group.reader_ids

    @readers = Reader.find(all_reader_ids - current_reader_ids)

    render_csv_of_readers
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

  private
  def require_branch_secretary
    @group = Group.find(params[:group_id])
    unless current_reader.is_secretary? and current_reader.groups.include? @group
      flash[:error] = 'You are not a group member or you are not a secretary'
      redirect_to root_path
    end
  end

  def render_csv_of_readers
    csv_string = FasterCSV.generate do |csv|
      csv << %w[nzffa_membership_id name email phone postal_address]
      @readers.each do |r|
        csv << [r.nzffa_membership_id, r.name, r.email, r.phone, r.postal_address_string]
      end
    end

    headers["Content-Type"] ||= 'text/csv'
    headers["Content-Disposition"] = "attachment; filename=\"#{@group.name}_#{action_name}_#{DateTime.now.to_s}\""
    render :text => csv_string
  end
end
