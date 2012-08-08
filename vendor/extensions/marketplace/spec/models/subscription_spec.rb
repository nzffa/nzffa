require 'spec_helper'

describe Subscription do
  before do
    @subscription = Subscription.new
  end
  it 'has associated branches' do
    @subscription.should respond_to :branches
  end

end
