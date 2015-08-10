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
      @readers = Reader.paginate(:page => params[:page], :conditions => [query_bits.join(' OR '), *token_bits], :order => 'surname, forename asc')
    else
      @readers = Reader.paginate(:page => params[:page], :order => 'surname, forename asc')
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

  

  private

    def load_reader
      @reader = Reader.find params[:id]
    end
end
