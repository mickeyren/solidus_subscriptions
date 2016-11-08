module SubscriptionStateMachine
  extend ActiveSupport::Concern
  included do
    class << self
      def active
        with_states %w(active renewing)
      end
    end

    state_machine initial: :active do
      event(:renew) { transition %i(active renewing) => :renewing }
      event(:renewed) { transition renewing: :active }

      after_transition any => :renewing, do: :mark_last_renewal!
      after_transition renewing: :active, do: :adjust_next_renewal!
    end
  end
end
