require 'lib/sells_subscriptions'
describe SellsSubscriptions do
  describe 'checkout' do
    let(:subscription) {stub(:subscription).as_null_object}
    it 'checks if the subscription is valid' do
      subscription.should_receive(:valid?).and_return(true)
      SellsSubscriptions.sell(subscription)
    end
    it 'creates an order object ready for payment'
  end
end

