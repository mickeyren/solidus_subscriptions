require 'spec_helper'

describe CreateSubscriptionJob do

  context "for existing users" do
    let!(:order) { create(:completed_order_with_totals) }

    it "creates a subscription from an order's eligible line items" do
      order.line_items.first.interval = 1
      order.line_items.first.product.subscribable = true
      user = order.user
      address_params = { firstname: "Sherry", lastname: "Son", address1: "123 Lafayette Street", city: "New York", zipcode: "10013", phone: "425-533-4994", state_id: 1, country_id: 1 }
      order.create_ship_address(address_params)
      order.create_bill_address(address_params)

      CreateSubscriptionJob.new.perform(order)

      subscription = user.subscriptions.first

      expect(user.subscriptions.count).to eq(1)
      expect(order.subscriptions).to_not be_nil
      expect(subscription.subscription_items.count).to eq(1)
      expect(subscription.ship_address.address1).to eq("123 Lafayette Street")
      expect(subscription.bill_address.address1).to eq("123 Lafayette Street")
    end
  end

  context "for nonexisting users" do
    let!(:order) { create(:completed_order_with_totals, user_id: nil) }
    it "a subscription is not created" do
      expect(order.state).to eq("complete")
      expect(order.user).to be_nil

      CreateSubscriptionJob.new.perform(order)

      expect(order.subscriptions).to be_empty
    end
  end
end
