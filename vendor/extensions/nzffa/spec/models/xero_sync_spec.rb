require File.dirname(__FILE__) + '/../spec_helper'

describe XeroSync do
  before(:each) do
    @xero_sync = XeroSync.new
  end

  it "should be valid" do
    @xero_sync.should be_valid
  end
end
