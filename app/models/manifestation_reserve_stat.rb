class ManifestationReserveStat < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  include CalculateStat
  scope :not_calculated, -> {in_state(:pending)}
  belongs_to :user

  has_one_attached :attachment
  paginates_per 10
  attr_accessor :mode

  has_many :manifestation_reserve_stat_transitions, autosave: false

  def state_machine
    ManifestationReserveStatStateMachine.new(self, transition_class: ManifestationReserveStatTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
           to: :state_machine

  private

  def self.transition_class
    ManifestationReserveStatTransition
  end

  def self.initial_state
    :pending
  end
end

# == Schema Information
#
# Table name: manifestation_reserve_stats
#
#  id           :bigint           not null, primary key
#  start_date   :datetime
#  end_date     :datetime
#  note         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  started_at   :datetime
#  completed_at :datetime
#  user_id      :bigint
#
