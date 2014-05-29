class ItemStateMachine
  include Statesman::Machine
  state :pending, initial: true
  state :on_loan
  state :available_on_shelf
  state :lost
  state :missing

  transition from: :pending, to: :available_on_shelf
  transition from: :available_on_shelf, to: [:on_loan, :missing]
  transition from: :on_loan, to: [:available_on_shelf, :missing]
  transition from: :missing, to: [:lost, :available_on_shelf, :on_loan]
  transition from: :lost, to: [:available_on_shelf, :on_loan]

  before_transition(to: :on_loan) do |item|
  end
end
