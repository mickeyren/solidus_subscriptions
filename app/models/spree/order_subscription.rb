module Spree
  class OrderSubscription < ActiveRecord::Base
    belongs_to :order
    belongs_to :subscription
  end
end
