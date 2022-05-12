include ActionView::Helpers::TextHelper
class Admin::Xero::OrdersController < Admin::ResourceController
  def index
    @unsynced_orders = Order.not_synced_to_xero.with_not_zero_amount.all(conditions: ["created_at >= ?", Time.new('2020')])
  end

  def sync
    unsynced_orders = Order.not_synced_to_xero.with_not_zero_amount.all(conditions: ["created_at >= ?", Time.new('2020')])
    unsynced_orders.each do |order|
      if order.xero_id
        order.update_xero_invoice
      else
        order.create_xero_invoice
      end
    end
    err_count = Order.not_synced_to_xero.with_not_zero_amount.all(conditions: ["created_at >= ?", Time.new('2020')]).count
    if err_count > 0
      flash[:error] = "#{pluralize(err_count, 'order')} failed to sync to Xero"
    else
      flash[:notice] = "Synced #{(unsynced_orders.size - err_count)} orders to Xero."
    end
    redirect_to action: :index
  end
end
