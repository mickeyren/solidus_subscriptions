class CreateSubscription
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def create
    begin
      create_subscription_from_eligible_items
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace
    end
  end

protected

  def create_subscription_from_eligible_items
    user = Spree::User.find_by_email(order.email)
    eligible_line_items.keys.each do |interval|
      attrs = {
        user_id: user.id,
        email: order.email,
        state: 'active',
        interval: interval,
        credit_card_id: order.credit_card_id_if_available
      }

      subscription = order.subscriptions.new(attrs)
      create_subscription_addresses(subscription, user)
      order.subscriptions << subscription
      create_subscription_items(subscription, interval)
    end
  end

  def eligible_line_items
    @eligible_line_items ||= order.line_items.group_by { |item| item.interval }.reject{ |interval| interval.nil? || interval.zero? }
  end

  def create_subscription_addresses(subscription, user)
    subscription.create_ship_address!(order.ship_address.dup.attributes.merge({user_id: user.id}))
    subscription.create_bill_address!(order.bill_address.dup.attributes.merge({user_id: user.id}))
  end

  def create_subscription_items(subscription, interval)
    eligible_line_items[interval].each do |line_item|
      next unless line_item.product.subscribable?
      Spree::SubscriptionItem.create!(
        subscription: subscription,
        variant: line_item.variant,
        quantity: line_item.quantity,
        interval: interval
      )
    end
  end

end
