class ManifestationCheckoutStatStateMachine
  include Statesman::Machine
  state :pending, initial: true
  state :started
  state :completed
  state :failed

  transition from: :pending, to: [:started, :failed]
  transition from: :started, to: [:completed, :failed]

  after_transition(to: :started) do |manifestation_checkout_stat|
    manifestation_checkout_stat.update_column(:started_at, Time.zone.now)
    manifestation_checkout_stat.calculate_count!
  end

  after_transition(to: :completed) do |manifestation_checkout_stat|
    manifestation_checkout_stat.update_column(:completed_at, Time.zone.now)
  end
end
