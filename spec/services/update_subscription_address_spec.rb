require 'spec_helper'

describe UpdateSubscriptionAddress do

  context "when updating a subscription" do
    let(:user) { create(:user) }
    let(:old_address) { create(:subscription_address, address1: "Old Address", user: user) }
    let(:subscription) { create(:subscription, ship_address: old_address, bill_address: old_address, user: user) }

    before do
      @new_address = build_address_params(old_address)
      @new_address[:address1] = "New Address"
      @new_address[:address2] = "New Address 2"
      @new_address[:city] = "Updated City"
      @new_address[:zipcode] = "11111"
    end

    it "admin users are able to update only the ship address" do
      subscription_params = {
        "interval": subscription.interval,
        "email": subscription.email,
        "ship_address_attributes": @new_address,
        "bill_address_attributes": old_address
      }
      UpdateSubscriptionAddress.new.update_address(subscription, subscription_params)

      updated_ship_address_params = build_address_params(subscription.ship_address)

      expect(subscription.ship_address.user_id).to eq(subscription.user_id)
      expect(updated_ship_address_params).to eq(@new_address)

      expect(subscription.bill_address).to eq(old_address)
    end

    it "admin users are able to update only the bill address" do
      subscription_params = {
        "interval": subscription.interval,
        "email": subscription.email,
        "ship_address_attributes": old_address,
        "bill_address_attributes": @new_address
      }
      UpdateSubscriptionAddress.new.update_address(subscription, subscription_params)

      updated_bill_address_params = build_address_params(subscription.bill_address)

      expect(subscription.bill_address.user_id).to eq(subscription.user_id)
      expect(updated_bill_address_params).to eq(@new_address)

      expect(subscription.ship_address).to eq(old_address)
    end

    it "admin users are able to update both the ship and bill addresses" do
      subscription_params = {
        "interval": subscription.interval,
        "email": subscription.email,
        "ship_address_attributes": @new_address,
        "bill_address_attributes": @new_address
      }
      UpdateSubscriptionAddress.new.update_address(subscription, subscription_params)

      updated_ship_address_params = build_address_params(subscription.ship_address)
      updated_bill_address_params = build_address_params(subscription.bill_address)

      expect(subscription.ship_address.user_id).to eq(subscription.user_id)
      expect(updated_ship_address_params).to eq(@new_address)

      expect(subscription.bill_address.user_id).to eq(subscription.user_id)
      expect(updated_bill_address_params).to eq(@new_address)

    end
  end

  def build_address_params(address)
    address = {
      firstname: address.firstname,
      lastname: address.lastname,
      address1: address.address1,
      address2: address.address2,
      city: address.city,
      zipcode: address.zipcode,
      country_id: address.country_id,
      state_id: address.state_id,
      phone: address.phone
    }
  end

end
