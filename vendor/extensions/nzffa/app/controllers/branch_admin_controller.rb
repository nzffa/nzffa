class BranchAdminController < MarketplaceController
  before_filter :require_branch_secretary
  before_filter :set_group
  radiant_layout { |c| Radiant::Config['reader.layout'] }

  def index
    @readers = @group.readers

    respond_to do |format|
      format.html
      format.csv { render_csv_of_readers }
      format.xls { render_xls_of_readers }
    end
  end

  def past_members
    @readers = @past_members = find_past_members

    respond_to do |format|
      format.html { render :index }
      format.csv { render_csv_of_readers }
      format.xls { render_xls_of_readers }
    end
  end

  def last_year_members
    @readers = @last_year_members = find_last_year_members

    respond_to do |format|
      format.html { render :index }
      format.csv { render_csv_of_readers }
      format.xls { render_xls_of_readers }
    end
  end

  def email
    @group_readers = @group.readers
    @readers = Reader.find(:all,
                       :conditions => ['(email NOT REGEXP "[0-9]+@nzffa.org.nz") AND
                                       readers.id IN (?)', @group_readers.map(&:id)])
  end

  def email_past_members
    @past_members = find_past_members
    @readers = Reader.find(:all,
                       :conditions => ['(email NOT REGEXP "[0-9]+@nzffa.org.nz") AND
                                       readers.id IN (?)', @past_members.map(&:id)])
    render :email
  end

  def email_last_year_members
    @last_year_members = find_last_year_members
    @readers = Reader.find(:all,
                       :conditions => ['(email NOT REGEXP "[0-9]+@nzffa.org.nz") AND
                                       readers.id IN (?)', @last_year_members.map(&:id)])
    render :email
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

  def start_of_last_year
    1.year.ago.at_beginning_of_year
  end

  def end_of_last_year
    1.year.ago.at_end_of_year
  end

  def find_past_members
    group_subscriptions = GroupSubscription.find(:all, :joins => :subscription, :conditions => ['group_id = ? and subscriptions.expires_on < ?', @group.id, end_of_last_year])
    subscriptions = Subscription.find(group_subscriptions.map(&:subscription_id))

    all_reader_ids = subscriptions.map(&:reader_id)
    current_reader_ids = @group.reader_ids

    Reader.find(:all, :conditions => {:id => (all_reader_ids - current_reader_ids)})
  end

  def find_last_year_members
    group_subscriptions = GroupSubscription.find(:all, :joins => :subscription, :conditions => ['group_id = ? and (subscriptions.expires_on > ? and subscriptions.expires_on < ?)', @group.id, start_of_last_year, end_of_last_year])
    subscription_ids = group_subscriptions.map(&:subscription_id)
    subscriptions = Subscription.find(subscription_ids)

    last_year_reader_ids = subscriptions.map(&:reader_id)
    current_reader_ids = @group.reader_ids

    Reader.find(:all, :conditions => {:id => (last_year_reader_ids - current_reader_ids)})
  end

  def require_branch_secretary
    require_reader
    @group = Group.find(params[:group_id])
    allowed_reader_ids = @group.homepage.try(:field, 'branch_admin_access_reader_ids').try(:content).to_s.split(',').map(&:to_i).compact
    allowed_reader_ids << @group.homepage.field('secretary_reader_id').try(:content).to_i
    unless allowed_reader_ids.include? current_reader.id
      raise ReaderError::AccessDenied, 'You are not a group member or you are not a secretary'
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

  def set_group
    @group = Group.find(params[:group_id])
  end
end
