class BranchAdminController < MarketplaceController
  before_filter :require_current_reader
  before_filter :require_branch_secretary
  radiant_layout "no_layout"

  def index
    @group = Group.find(params[:group_id])
    @readers = @group.readers

    respond_to do |format|
      format.html
      format.csv { render_csv_of_readers }
      format.xls { render_xls_of_readers }
    end
  end

  def past_members
    @group = Group.find(params[:group_id])
    group_subscriptions = GroupSubscription.find_all_by_group_id(@group.id)
    subscription_ids = group_subscriptions.map(&:subscription_id)
    subscriptions = Subscription.find(subscription_ids)

    all_reader_ids = subscriptions.map(&:reader_id)
    current_reader_ids = @group.reader_ids

    @readers = Reader.find(:all, :conditions => {:id => (all_reader_ids - current_reader_ids)})

    respond_to do |format|
      format.html { render :index }
      format.csv { render_csv_of_readers }
      format.xls { render_xls_of_readers }
    end
  end

  def last_year_members
    @group = Group.find(params[:group_id])
    
    start_of_last_year = 1.year.ago.at_beginning_of_year
    end_of_last_year= 1.year.ago.at_end_of_year
    group_subscriptions = GroupSubscription.find(:all, :joins => :subscription, :conditions => ['group_id = ? and (subscriptions.begins_on > ? and subscriptions.expires_on < ?)', @group.id, start_of_last_year, end_of_last_year])
    subscription_ids = group_subscriptions.map(&:subscription_id)
    subscriptions = Subscription.find(subscription_ids)

    last_year_reader_ids = subscriptions.map(&:reader_id)
    current_reader_ids = @group.reader_ids

    @readers = Reader.find(:all, :conditions => {:id => (last_year_reader_ids - current_reader_ids)})

    respond_to do |format|
      format.html { render :index }
      format.csv { render_csv_of_readers }
      format.xls { render_xls_of_readers }
    end
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
    if RUBY_VERSION =~ /1.9/
      require 'csv'
      csv_lib = CSV
    else
      csv_lib = FasterCSV
    end
    csv_string = csv_lib.generate do |csv|
      csv << %w[nzffa_membership_id name email phone postal_address]
      @readers.each do |r|
        csv << [r.nzffa_membership_id, r.name, r.email, r.phone, r.postal_address_string]
      end
    end

    headers["Content-Type"] ||= 'text/csv'
    headers["Content-Disposition"] = "attachment; filename=\"#{@group.name.slugify}_#{action_name}_#{DateTime.now.to_s}\""
    render :text => csv_string
  end
  
  def render_xls_of_readers()
    require 'spreadsheet'
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => 'Readers export'
    columns = %w(nzffa_membership_id name email phone postal_address_string)
        
    sheet.row(0).replace(["#{@group.name} downloaded #{Time.now.strftime("%Y-%m-%d")}"])
    sheet.row(1).replace(columns.map{|k| k.capitalize})
    
    @readers.each_with_index do |reader, i|
      sheet.row(i+2).replace(columns.map {|k| reader.send(k)})
    end
    
    filename = "#{@group.name.slugify}-#{Time.now.strftime("%Y-%m-%d")}.xls"
    tmp_file = Tempfile.new(filename)
    book.write tmp_file.path
    send_file tmp_file.path, :filename => filename
  end
end
