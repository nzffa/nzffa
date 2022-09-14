class Admin::SubscriptionsController < AdminController
  only_allow_access_to :index, :new, :edit, :create, :update, :remove, :destroy,
    :when => [:admin, :designer]

  before_filter :load_reader, :only => [:new, :create]

  def batches_to_print
    read_batch_params
    @options = batch_params_hash
    @subs_by_postcode = subs_by_postcode_from_batch_params
  end

  def print_batch
    read_batch_params
    @subs_by_postcode = subs_by_postcode_from_batch_params

    @unsaved_orders = @subs_by_postcode[@postcode].map do |sub|
                        sub.begins_on = (@expiring_on - 1.year).at_beginning_of_year
                        sub.expires_on = (@expiring_on - 1.year)
                        CreateOrder.from_subscription(sub)
                      end
    render :layout => false
  end

  def index
    @subscriptions = Subscription.paginate(:page => params[:page], :order => 'id desc')
  end

  def show
    @subscription = Subscription.find(params[:id])
  end

  def print
    @subscription = Subscription.find(params[:id])
    @order = @subscription.order
    render 'subscriptions/print', :layout => false
  end

  def print_renewal
    old_sub = Subscription.find(params[:id])
    @subscription = old_sub.renew_for_year(old_sub.expires_on.year + 1)
    @order = CreateOrder.from_subscription(@subscription)
    render 'subscriptions/print', :layout => false
  end

  def new
    if @existing_sub = Subscription.active_subscription_for(@reader)
      redirect_to edit_admin_subscription_path(@existing_sub)
    else
      @action_path = admin_reader_subscriptions_path(@reader)
      @subscription = Subscription.new(params[:subscription])
      @subscription.reader = @reader
      render 'subscriptions/new'
    end
  end

  def edit
    if @subscription = Subscription.find_by_id(params[:id])
      unless @subscription.paid?
        flash[:error] = 'You cannot upgrade a subscription if it has not beed paid'
        redirect_to admin_subscription_path(@subscription) and return
      end
      @action_path = admin_subscription_path(@subscription)
      @subscription.begins_on = Date.today
      @subscription.contribute_to_research_fund = false
      render 'subscriptions/modify'
    else
      flash[:error] = 'subscription not found'
      redirect_to admin_subscriptions_path
    end
  end

  def renew
    old_sub = Subscription.find(params[:id])
    @subscription = old_sub.renew_for_year(old_sub.begins_on.year + 1)
    @action_path = admin_reader_subscriptions_path(@subscription.reader)
    render 'subscriptions/new'
  end

  def create
    @subscription = Subscription.new(params[:subscription])
    @subscription.reader = @reader

    if @subscription.save!
      @order = CreateOrder.from_subscription(@subscription)
      @order.add_extra_products_from_params_hash(params[:products])
      @order.save
      redirect_to edit_admin_order_path(@order)
    else
      render :new
    end
  end

  def update
    current_sub = Subscription.find(params[:id])
    unless current_sub.paid?
      flash[:error] = 'You cannot upgrade a subscription if it has not beed paid'
      redirect_to admin_subscription_path(@subscription) and return
    end
    new_sub = Subscription.new(params[:subscription])
    new_sub.reader = current_sub.reader
    if new_sub.valid?
      @order = CreateOrder.upgrade_subscription(:from => current_sub, :to => new_sub)
      @order.add_extra_products_from_params_hash(params[:products])
      @order.amount = @order.calculate_amount # because of added CC order_line
      @order.save
      redirect_to edit_admin_order_path(@order)
    else
      render :edit
    end
  end

  def cancel
    if @subscription = Subscription.find(params[:id])
      unless @subscription.paid?
        @subscription.cancel!
      else
        flash[:error] = 'You cannot cancel a paid subscription.. only modify it'
      end
    end

    redirect_to :back
  end

  def reapply_subscription_groups
    render :text => proc { |response, output|
      Reader.find_each do |reader|
        next if reader.is_resigned?
        before_ids = reader.group_ids.uniq
        AppliesSubscriptionGroups.remove(reader)
        if reader.has_active_subscription?
          AppliesSubscriptionGroups.apply(reader.active_subscription, reader)
        end
        after_ids = reader.group_ids.uniq
        removed_ids = before_ids - after_ids
        added_ids = after_ids - before_ids
        unless removed_ids.empty?
          output.write "Removed #{removed_ids.inspect} from reader_id: #{reader.id}\n"
        end
        if added_ids.any?
          output.write "Added #{added_ids.inspect} to reader_id: #{reader.id}\n"
        end
      end

      output.write "Rebuilding non-renewed members groups ...\n"
      group = Group.find(NzffaSettings.non_renewed_members_group_id)
      group.readers.clear
      last_year_subscriptions = Subscription.find(:all, :conditions => ['expires_on > ? and expires_on < ?', 1.year.ago.beginning_of_year, 1.year.ago.end_of_year])
      last_year_member_ids = last_year_subscriptions.map(&:reader_id)
      active_member_ids = Subscription.active.map(&:reader_id)
      non_renewed_members = Reader.find(:all, :conditions => {:id => (last_year_member_ids - active_member_ids)}).select{|r| !r.is_resigned? }
      group.readers << non_renewed_members
      output.write "Added #{non_renewed_members.size} readers to non_renewed_members group\n"
    }, :content_type => 'text/plain'
  end

  def subs_by_postcode_from_batch_params
    if @expiring_on <= Date.today
      # has expired or expires today, so scope to active_anytime;
      @subscriptions = Subscription.active_anytime.with_readers_having_no_real_email_or_disallowing_renewal_mails.expiring_on(@expiring_on)
      # remove subs where the reader already has an active subscription
      @subscriptions = @subscriptions.delete_if {|s| s.reader.nil? || s.reader.has_active_subscription? }
    else
      # yet to expire, so scope to active;
      @subscriptions = Subscription.active.with_readers_having_no_real_email_or_disallowing_renewal_mails.expiring_on(@expiring_on)
      # remove subs where the reader already has a subscription for next year
      @subscriptions = @subscriptions.delete_if {|s| s.reader.nil? || s.reader.has_subscription_for_next_year? }
    end
    @subscriptions.group_by{|s| s.reader.postcode }
  end

  private

  # def subscriptions_in_batches
  #   Subscription.expiring_before(@expiring_on).each_slice(@batch_size)
  # end

  def load_reader
    unless params[:reader_id]
      flash[:error] = 'reader_id required'
      redirect_to admin_readers_plus_path and return
    end
    @reader = Reader.find(params[:reader_id])
  end

  def read_batch_params
    @postcode = params.fetch(:postcode) { nil }
    @expiring_on = Date.parse(params.fetch(:expiring_on) { Date.today.end_of_year.strftime("%Y-%m-%d") })
  end

  def batch_params_hash
    {:expiring_on => @expiring_on,
     :postcode => @postcode}
  end
end
