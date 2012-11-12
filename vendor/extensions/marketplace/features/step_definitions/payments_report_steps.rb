Given /^there is a reader called John Tree$/ do
  @john_tree = Reader.create!(:forename => 'John',
                              :surname => 'Tree',
                              :email => 'john@tree.com',
                              :post_line1 => 'an address',
                              :post_province => 'province line',
                              :postcode => '12345',
                              :password => 'secret',
                              :password_confirmation => 'secret')
end

Given /^there is a reader called Helen Bark$/ do
  @helen_bark = Reader.create!(:forename => 'Helen',
                              :post_line1 => 'an address',
                              :post_province => 'province line',
                              :postcode => '12345',
                             :surname => 'Bark',
                             :email => 'helen@bark.com',
                             :password => 'secret',
                             :password_confirmation => 'secret')
end

Given /^John Tree created a full membership$/ do
  subscription = Subscription.create!(:reader => @john_tree,
                                      :membership_type => 'full',
                                      :ha_of_planted_trees => '11 - 40',
                                      :belong_to_fft => false,
                                      :main_branch_name => 'North Otago',
                                      :associated_branch_names => ['South Canterbury'],
                                      :receive_tree_grower_magazine => false,
                                      :begins_on => Date.parse('2012-01-01'),
                                      :expires_on => Date.parse('2012-12-31'))
  @jt_order = CreateOrder.from_subscription(subscription)
  @jt_order.save!
  @jt_order.paid!('Online')
end

def create_order_from_subscription(subscription)
  if subscription.valid?

  
    levy = CalculatesSubscriptionLevy.levy_for(subscription)
    order = Order.create!(:amount => levy,
                          :subscription => subscription,
                          :payment_method => 'Online')
                          
  else
    raise "subscription invalid: #{subscription.errors.inspect}"
  end
end

Given /^Helen Bark created a casual membership$/ do
  @hb_sub1 = Subscription.create!(:reader => @helen_bark,
                                  :membership_type => 'casual',
                                  :belong_to_fft => true,
                                  :receive_tree_grower_magazine => false,
                                  :begins_on => Date.parse('2012-01-01'),
                                  :expires_on => Date.parse('2012-12-31'))
  @hb_order = CreateOrder.from_subscription(@hb_sub1)
  @hb_order.paid!('Online')
end

Given /^Helen Bark upgraded her casual membership$/ do
  @hb_sub2 = Subscription.create!(:reader => @helen_bark,
                                  :membership_type => 'casual',
                                  :belong_to_fft => true,
                                  :receive_tree_grower_magazine => true,
                                  :tree_grower_delivery_location => 'new_zealand',
                                  :nz_tree_grower_copies => 1,
                                  :begins_on => Date.parse('2012-01-01'),
                                  :expires_on => Date.parse('2012-12-31'))
  @hb_order2 = CreateOrder.upgrade_subscription(:from => @hb_sub1,
                                                :to => @hb_sub2)
  @hb_order2.paid!('Online')
end

When /^I download the payment report$/ do
  visit payments_admin_reports_path
end

Then /^I should see a payment from John Tree$/ do
  fields = ['nzffa_member_id', 'subscription_id', 'order_id', 'amount', 'paid_on', 'payment_method']
  page.should have_content "#{@jt_order.nzffa_member_id},#{@jt_order.subscription_id},#{@jt_order.id},#{@jt_order.amount},#{Date.today},Online"
end

Then /^I should see a payment from Helen Bark$/ do
  fields = ['nzffa_member_id', 'subscription_id', 'order_id', 'amount', 'paid_on', 'payment_method']
  page.should have_content "#{@hb_order.nzffa_member_id},#{@hb_order.subscription_id},#{@hb_order.id},#{@hb_order.amount},#{Date.today},Online"
end

When /^I download the allocations report$/ do
  visit allocations_admin_reports_path
end

Then /^I should see the allocations to from JT's payment$/ do |arg1|
  fields = ['nzffa_member_id', 'subscription_id', 'order_id', 'order_line_id', 'kind', 'particular', 'amount', 'paid_on', 'payment_method']
  @jt_order.order_lines.each do |line|
    page.should have_content "#{@jt_order.nzffa_member_id},#{@jt_order.subscription_id},#{@jt_order.order_id},#{line.order_line_id},#{line.kind},#{line.particular},#{line.amount},#{Date.today},Online"
  end
end

Then /^I should see an allocation to North Otago for (\d+) from JT's payment$/ do |arg1|
  fields = ['nzffa_member_id', 'subscription_id', 'order_id', 'order_line_id', 'kind', 'particular', 'amount', 'paid_on', 'payment_method']
  @jt_order.order_lines.each do |line|
    page.should have_content fields.map{|f| "#{line.send(f)}"}.join(',')
  end
end


Then /^I should see an allocation refund of$/ do
  pending # express the regexp above with the code you wish you had
end
