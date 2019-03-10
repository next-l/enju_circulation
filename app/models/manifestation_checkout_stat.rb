class ManifestationCheckoutStat < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  include CalculateStat
  scope :not_calculated, -> {in_state(:pending)}
  has_many :checkout_stat_has_manifestations
  has_many :manifestations, through: :checkout_stat_has_manifestations
  belongs_to :user

  has_one_attached :attachment
  paginates_per 10
  attr_accessor :mode

  has_many :manifestation_checkout_stat_transitions, autosave: false

  def state_machine
    ManifestationCheckoutStatStateMachine.new(self, transition_class: ManifestationCheckoutStatTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
           to: :state_machine

  def calculate_count!
    self.started_at = Time.zone.now
    results = Checkout.returned.where('checkouts.created_at >= ? AND checkouts.created_at < ?', start_date.beginning_of_day, end_date.tomorrow.beginning_of_day).group(:manifestation_id).select('manifestation_id, count(manifestation_id)').joins(:item).map{|a| [a.manifestation_id, a.count]}
    results.each do |result|
     CheckoutStatHasManifestation.create(
        manifestation_checkout_stat: self,
        manifestation_id: result[0],
        checkouts_count: result[1]
      )
    end
    # attachment.attach(io: StringIO.new(results.to_h.to_json), filename: "result_#{start_date}_#{end_date}.txt")
    self.completed_at = Time.zone.now
    transition_to!(:completed)
    send_message
  end

  private

  def self.transition_class
    ManifestationCheckoutStatTransition
  end

  def self.initial_state
    :pending
  end
end

# == Schema Information
#
# Table name: manifestation_checkout_stats
#
#  id           :uuid             not null, primary key
#  start_date   :datetime
#  end_date     :datetime
#  note         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  started_at   :datetime
#  completed_at :datetime
#  user_id      :bigint(8)
#
