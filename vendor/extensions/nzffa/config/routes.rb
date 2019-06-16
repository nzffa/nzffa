ActionController::Routing::Routes.draw do |map|
  map.resources :subscriptions, :except => [:destroy, :edit, :update],
    :collection => { :quote_new => :post,
                     :quote_upgrade => :post,
                     :modify => :get,
                     :upgrade => :put,
                     :renew => :get,
                     :print_renewal => :get,
                     :print => :get,
                     :cancel => :post}

  map.resources :orders, :only => [],
   :member => { :make_payment => :get },
   :collection => { :payment_finished => :get }

  map.membership_details '/membership/details', :controller => :membership, :action => :details
  map.register_membership '/membership/register', :controller => :membership, :action => :register
  map.update_membership '/membership/update', :controller => :membership, :action => :update

  map.branch_admin '/branch_admin/:group_id.:format', :controller => :branch_admin, :action => :index
  map.branch_admin_past_members '/branch_admin/:group_id/past_members.:format', :controller => :branch_admin, :action => :past_members
  map.branch_admin_last_year_members '/branch_admin/:group_id/last_year_members.:format', :controller => :branch_admin, :action => :last_year_members
  map.branch_admin_past_fft_members '/branch_admin/:group_id/past_fft_members', :controller => :branch_admin, :action => :past_fft_members

  map.branch_admin_email '/branch_admin/:group_id/email', :controller => :branch_admin, :action => :email
  map.branch_admin_email_past_members '/branch_admin/:group_id/email_past_members', :controller => :branch_admin, :action => :email_past_members
  map.branch_admin_email_last_year_members '/branch_admin/:group_id/email_last_year_members', :controller => :branch_admin, :action => :email_last_year_members
  map.branch_admin_edit '/branch_admin/:group_id/edit/:nzffa_membership_id', :controller => :branch_admin, :action => :edit
  map.branch_admin_update '/branch_admin/:group_id/update/:nzffa_membership_id', :controller => :branch_admin, :action => :update
  map.new_reader "/become-a-member", :controller => 'membership', :action => 'register'

  map.namespace :admin do |admin|
    admin.resources :reports,
      :only => :index,
      :collection => {
        :past_members_no_subscription => :get,
        :payments => :get,
        :allocations => :get,
        :members => :get,
        :members_w_subscription_renewal_optout => :get,
        :national_newsletter_members_selection => :get,
        :deliveries => :get,
        :expiries => :get
      }
    admin.resources :subscriptions,
      :member     => { :print => :get,
                       :print_renewal => :get,
                       :renew => :get },
      :collection => { :batches_to_print => :get,
                       :print_batch => :get}
    admin.resources :readers_plus,
      :except => [:new, :create],
      :member => [:create_user]
    admin.resources :orders
    admin.resources :readers, :only => [] do |readers|
     readers.resources :orders, :only => :index
     readers.resources :subscriptions, :member => { :cancel => :post }
    end
  end
end
