class UpdateIntervalOnSpreeSubscriptionsDefaultToBeZero < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :interval, :integer, default: 0
  end
end
