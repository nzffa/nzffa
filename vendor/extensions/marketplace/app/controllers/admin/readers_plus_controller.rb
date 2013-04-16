class Admin::ReadersPlusController < AdminController
  include ActionView::Helpers::ActiveRecordHelper
  include ActionView::Helpers::TagHelper

  only_allow_access_to :index, :new, :edit, :create, :update, :remove, :destroy,
    :when => [:admin, :designer]

  def index
    if params[:page].blank?
      params[:page] = 1
    end
    if token = params[:query]
      search_cols = %w[forename surname email nzffa_membership_id id]
      query_bits = []
      token_bits = []
      search_cols.each do |col|
        query_bits << "#{col} LIKE ?"
        token_bits << "%#{token}%"
      end
      @readers = Reader.paginate(:page => params[:page], :conditions => [query_bits.join(' OR '), *token_bits], :order => 'surname asc')
    else
      @readers = Reader.paginate(:page => params[:page])
    end
  end

  def edit
    load_reader
  end

  def show
    load_reader
    @current_subscription = Subscription.current_subscription_for(@reader)
  end

  def update
    load_reader
    @reader.attributes = params[:reader]
    if @reader.save
      flash[:notice] = 'Updated reader'
      redirect_to [:admin, :readers_plus]
    else
      render :edit
    end
  end

  def create_user
    load_reader
    @user = @reader.build_user
    if @user
      if @user.save
        @reader.update_attribute(:user_id, @user.id)
        flash[:notice] = "Created user #{@user.login}"
      else
        flash[:error] = error_messages_for(:user)
      end
    end
    redirect_to [:admin, :readers_plus]
  end

  private

    def load_reader
      @reader = Reader.find params[:id]
    end
end
