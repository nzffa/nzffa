require File.dirname(__FILE__) + '/../spec_helper'

describe XeroOrderSync do
  before(:each) do
    @xero_order_sync = XeroOrderSync.new
  end

  it "should be valid" do
    @xero_order_sync.should be_valid
  end
end
