class AdjustSkuService

	def update_subscriptions(old_sku, new_sku)
    variant1 = Spree::Variant.find_by(sku: old_sku)
    variant2 = Spree::Variant.find_by(sku: new_sku)
    subscriptions = []
    items = subscription_items(variant1)
    for item in items
      create_subscription_item(item, variant2)
      subscriptions << item.subscription
      items.delete(item)
    end
    subscriptions
  end

  def subscription_items(variant)
    subscription_items = Spree::SubscriptionItem.where(variant_id: variant.id)
  end

  def create_subscription_item(old_subscription_item, variant)
    subscription = old_subscription_item.subscription
    subscription.subscription_items.create!(
      variant_id: variant.id, quantity: old_subscription_item.quantity, price: old_subscription_item.price, cost_price: old_subscription_item.cost_price, \
      tax_category_id: old_subscription_item.tax_category_id, adjustment_total: old_subscription_item.adjustment_total, additional_tax_total: old_subscription_item.additional_tax_total, \
      promo_total: old_subscription_item.promo_total, included_tax_total: old_subscription_item.included_tax_total, pre_tax_amount: old_subscription_item.pre_tax_amount, interval: old_subscription_item.interval)
  end

end
