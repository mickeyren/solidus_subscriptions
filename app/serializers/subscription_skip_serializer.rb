class SubscriptionSkipSerializer < ActiveModel::Serializer
  extend Spree::Api::ApiHelpers
  cache
  delegate :cache_key, to: :object

  attributes :id, :skip_at, :undo_at
end
