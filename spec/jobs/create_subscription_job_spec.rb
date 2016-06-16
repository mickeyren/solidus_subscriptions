require 'spec_helper'

describe CreateSubscriptionJob do

  context "for existing users" do
    let(:product) { create(:subscribable_product) }
    let(:order) {
      address = create(:address, address1: "123 Lafayette Street")
      order = create(:completed_order_with_totals, bill_address: address, ship_address: address)
      order.line_items << create(:line_item, variant: product.master, interval: 2)
      order
     }

    it "creates a subscription from an order's eligible line items" do
      CreateSubscriptionJob.new.perform(order.id)

      subscription = order.subscriptions.first
      expect(order.subscriptions.count).to eq(1)
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

      CreateSubscriptionJob.new.perform(order.id)

      expect(order.subscriptions).to be_empty
    end
  end
end
