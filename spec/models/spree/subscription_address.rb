require 'spec_helper'

describe Spree::SubscriptionAddress do

  let(:subscription_address) { create(:subscription_address) }

  it "is not readonly" do
    expect(subscription_address.readonly?).to be(false)
  end
end
