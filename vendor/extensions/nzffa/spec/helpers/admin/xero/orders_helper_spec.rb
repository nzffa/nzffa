require File.dirname(__FILE__) + '/../../../spec_helper'

describe Admin::Xero::OrdersHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the Admin::Xero::OrdersHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(Admin::Xero::OrdersHelper)
  end
  
end
