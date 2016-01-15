require "spec_helper"

feature "Subscription", type: :request do
  include SubscriptionMacros

  before(:each) do
    user = create(:user)
    setup_subscription_for user
    sign_in_as! user
  end

  context "Subscription" do
    before(:each) do
      @my_account = MyAccount::Page.new
    end

    scenario "can be cancelled" do
      subscription = @my_account.subscriptions.first

      subscription.cancel

      expect(subscription.state).to eq('Cancelled')
      expect(subscription).to_not have_css(".pause-subscription")
      expect(subscription).to_not have_css(".cancel-subscription")
    end
  end

end
