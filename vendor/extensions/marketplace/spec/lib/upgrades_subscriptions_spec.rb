require 'lib/upgrades_subscriptions'
require 'lib/calculates_subscription_levy'
require 'activesupport'
require 'timecop'

#describe UpgradesSubscriptions do
  #describe 'quoting upgrade cost' do
    #let(:current_sub){
      #stub(:current_sub,
          #{:expires_on => Date.parse('2012-12-31'),
           #:order => stub(:amount => 50,
                          #:paid? => true,
                          #:paid_on => Date.parse('2012-01-01'))})
    #}

    #let(:new_sub){
      #stub(:new_sub,
          #{:expires_on => Date.parse('2012-12-31'),
           #:order => stub(:amount => 50)})
    #}

    #it 'calculates unused duration of current subscription' do
      #Timecop.freeze('2012-06-01')
      #upgrader = UpgradesSubscriptions.new(:current => current_sub, :new => new_sub)
      #upgrader.unused_duration_in_years.should == 0.5
      #Timecop.return
    #end

    #it 'calculates credit on current subscription' do
      ##credit on current subscription is cost of subscription * unused duration
      ##either.. what they were charged or
      #upgrader = UpgradesSubscriptions.new(:current => current_sub, :new => new_sub)
      #upgrader.credit_on_current_subscription.should == 25
    #end

    #it 'calculates cost to upgrade to new subscription' do
      #upgrader.upgrade_price.should == 
    #end
  #end

  #describe 'upgrading' do
    #it 'cancels the current subscription'
    #it 'creates the new subscription'
    #it 'creates an order for the upgrade cost'
  #end
#end

