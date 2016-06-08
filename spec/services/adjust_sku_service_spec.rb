require 'spec_helper'

describe AdjustSkuService do
  let(:address) { create(:subscription_address) }
  let(:user) { create(:user) }
  let(:product) { create(:base_product) }
  let(:product2) { create(:base_product)}

  before do
    @old_variant = product.variants.create!(sku: "bdc1")
    @new_variant = product.variants.create!(sku: "bdc2")
    @subscription = user.subscriptions.create!(ship_address_id: address.id, bill_address_id: address.id)
    @subscription.subscription_items.create!(variant_id: @old_variant.id, quantity: 5, price: 10.00, interval: 2)
  end

  context "when updating a sku" do
    it "the corresponding subscription item is updated to the new variant sku" do
      AdjustSkuService.new.update_subscriptions("bdc1", "bdc2")

      expect(@subscription.subscription_items.count).to eq(1)
      expect(@subscription.subscription_items.first.variant_id).to be(@new_variant.id)
    end

    it "unaffected subscription items are not changed" do
      variant2 = product2.variants.create!(sku: "gmask1")
      @subscription.subscription_items.create!(variant_id: variant2.id, quantity: 1, price: 10.00 )

      AdjustSkuService.new.update_subscriptions("bdc1", "bdc2")

      expect(@subscription.subscription_items.count).to eq(2)
      expect(@subscription.subscription_items[0].variant_id).to be(variant2.id)
      expect(@subscription.subscription_items[1].variant_id).to be(@new_variant.id)
    end

    it "all affected subscriptions are updated" do
      user2 = FactoryGirl.create(:user)
      subscription2 = user2.subscriptions.create!(ship_address_id: address.id, bill_address_id: address.id)
      subscription2.subscription_items.create!(variant_id: @old_variant.id, quantity: 1, price: 10.00)

      AdjustSkuService.new.update_subscriptions("bdc1", "bdc2")

      expect(@subscription.subscription_items.count).to eq(1)
      expect(@subscription.subscription_items.first.variant_id).to be(@new_variant.id)
      expect(subscription2.subscription_items.count).to eq(1)
      expect(subscription2.subscription_items.first.variant_id).to be(@new_variant.id)
    end

    it "when updating subscription items, it's other attributes remain the same" do
      AdjustSkuService.new.update_subscriptions("bdc1", "bdc2")

      expect(@subscription.subscription_items.first).to have_attributes(quantity: 5, interval: 2, variant_id: @new_variant.id)
    end
  end


  it "gets all subscription items with a specific sku" do
    user2 = FactoryGirl.create(:user)
    subscription2 = user2.subscriptions.create!(ship_address_id: address.id, bill_address_id: address.id)
    subscription2.subscription_items.create!(variant_id: @old_variant.id, quantity: 1, price: 10.00)

    subscription_items = AdjustSkuService.new.subscription_items(@old_variant)

    expect(subscription_items.count).to eq(2)
  end

  it "creates a subscription item with the updated variant sku" do
    item = @subscription.subscription_items.first

    AdjustSkuService.new.create_subscription_item(item, @new_variant)

    expect(@subscription.subscription_items.last.variant.sku).to eq("bdc2")
  end

end
