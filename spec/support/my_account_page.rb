module MyAccount

  class Page
    include Capybara::DSL

    def initialize
        visit "/account"
    end

    def subscriptions
      Subscriptions.new(find("div#content table.subscription-summary"))
    end
  end

  class Subscriptions
    include Capybara::DSL

    def initialize(subscriptions)
      @subscriptions = subscriptions
    end

    def first
      Subscription.new(@subscriptions.find("tbody > tr:first-of-type"))
    end
  end

  class Subscription
    include Capybara::DSL

    def initialize(subscription)
      @subscription = subscription
    end

    def pause
      @subscription.find(".pause-subscription").click
      refresh
    end

    def resume(resume_on_date)
      @subscription.fill_in("subscription[resume_at]", with: resume_on_date)
      @subscription.find(".resume-subscription").click
      refresh
    end

    def cancel
      @subscription.find(".cancel-subscription").click
      refresh
    end

    def state
      @subscription.find("td:nth-of-type(4)").text
    end

    def refresh
      @subscription.reload
    end

  end
end
