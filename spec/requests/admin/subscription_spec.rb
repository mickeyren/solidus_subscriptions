require 'spec_helper'

feature 'Subscription' do
  stub_authorization!

  context "listing subscriptions" do
    scenario "should list all subscriptions" do
      visit spree.admin_path
      click_link "Subscriptions"
    end
  end

  context "updating subscriptions" do
    let(:order) {
      order = create(:completed_order_with_totals, bill_address: address, ship_address: address)
      order.line_items << create(:line_item, variant: product.master, interval: 2)
     }
    before do
      product = FactoryGirl.create(:subscribable_product)
      order = FactoryGirl.create(:completed_order_with_totals)
      order.line_items << create(:line_item, variant: product.master, interval: 2)
      CreateSubscriptionJob.new.perform(order.id)
    end

    scenario "can update a subscriptions address" do
      visit spree.admin_path
      click_link "Subscriptions"
      click_link("Edit", visible: false)

      fill_in("subscription_bill_address_attributes_address1", with: "updated address 1")

      fill_in("subscription_ship_address_attributes_address1", with: "updated address 1")

      click_button("Update")

      expect(page).to have_field("subscription_bill_address_attributes_address1", with: "updated address 1")

      expect(page).to have_field("subscription_ship_address_attributes_address1", with: "updated address 1")
    end

  end

end
