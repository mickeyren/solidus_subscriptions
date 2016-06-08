class UpdateIntervalOnSpreeSubscriptionsDefaultToBeZero < ActiveRecord::Migration
  def change
    change_column :spree_subscriptions, :interval, :integer, default: 0
  end
end
