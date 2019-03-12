require File.dirname(__FILE__) + '/../spec_helper'

describe GroupSubscription do
  before(:each) do
    @group_subscription = GroupSubscription.new
  end

  it "should be valid" do
    @group_subscription.should be_valid
  end
end
