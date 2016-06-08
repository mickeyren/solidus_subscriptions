RSpec.shared_context "setup subscriptions for adjusting skus" do
  before do
    user = FactoryGirl.create(:user, email: "sherry@glossier.com")
    product = FactoryGirl.create(:product, name: "Priming Moisturizer")
    gpm100 = product.variants.create(sku: "GPM100")
    product.variants.create(sku: "GPM100-2")
    FactoryGirl.create(:country, id: 49)
    address = Spree::SubscriptionAddress.create(firstname: "sherry", lastname: "son", address1: "123 Lafayette Street", address2: "Floor 3", city: "New York", zipcode: "10013", phone: "425-533-4994", state_name: "NY", state_id: 48, country_id: 49)

    order = FactoryGirl.create(:completed_order_with_totals, user_id: user.id)
    order.line_items.create(variant_id: gpm100.id, quantity: 1)

    @subscription = order.subscriptions.create(user_id: user.id, ship_address_id: address.id, bill_address_id: address.id, interval: 1)
    @subscription.subscription_items.create(variant_id: gpm100.id, quantity: 1)
  end
end
