require 'spec_helper'

describe CreateSubscriptionJob do
  let!(:order) { create(:completed_order_with_totals) }

  context "for existing users" do
    it "creates a subscription from an order's eligible line items" do
      order.line_items.first.interval = 1
      order.line_items.first.product.subscribable = true
      user = order.user
      order.create_ship_address(firstname: "Sherry", lastname: "Son", address1: "123 Lafayette Street", city: "New York", zipcode: "10013", phone: "425-533-4994", state_id: 1, country_id: 1)
      order.create_bill_address(firstname: "Sherry", lastname: "Son", address1: "123 Lafayette Street", city: "New York", zipcode: "10013", phone: "425-533-4994", state_id: 1, country_id: 1)

      CreateSubscriptionJob.new.perform(order)

      subscription = user.subscriptions.first

      expect(user.subscriptions.count).to eq(1)
      expect(subscription.subscription_items.count).to eq(1)
      expect(subscription.ship_address.address1).to eq("123 Lafayette Street")
      expect(subscription.bill_address.address1).to eq("123 Lafayette Street")
    end
  end
end
