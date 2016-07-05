class UpdateSubscriptionAddress

  def update_address(subscription, subscription_params)
    new_ship_address = subscription_params[:ship_address_attributes]
    new_bill_address = subscription_params[:bill_address_attributes]

    update_ship_address(subscription, new_ship_address) if subscription.ship_address != new_ship_address
    update_bill_address(subscription, new_bill_address) if subscription.bill_address != new_bill_address
  end


  def update_ship_address(subscription, new_ship_address)
    subscription.ship_address.update_columns(new_ship_address)
  end

  def update_bill_address(subscription, new_bill_address)
    subscription.bill_address.update_columns(new_bill_address)
  end

end
