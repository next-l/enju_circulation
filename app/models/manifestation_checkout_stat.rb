class ManifestationCheckoutStat < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordModel
  include CalculateStat
  default_scope {order('manifestation_checkout_stats.id DESC')}
  scope :not_calculated, -> {in_state(:pending)}
  has_many :checkout_stat_has_manifestations
  has_many :manifestations, :through => :checkout_stat_has_manifestations

  paginates_per 10
  attr_accessor :mode

  has_many :manifestation_checkout_stat_transitions

  def state_machine
    ManifestationCheckoutStatStateMachine.new(self, transition_class: ManifestationCheckoutStatTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
    to: :state_machine

  def calculate_count!
    self.started_at = Time.zone.now
    Manifestation.find_each do |manifestation|
      daily_count = Checkout.manifestations_count(start_date.beginning_of_day, end_date.tomorrow.beginning_of_day, manifestation)
      #manifestation.update_attributes({:daily_checkouts_count => daily_count, :total_count => manifestation.total_count + daily_count})
      if daily_count > 0
        self.manifestations << manifestation
        sql = ['UPDATE checkout_stat_has_manifestations SET checkouts_count = ? WHERE manifestation_checkout_stat_id = ? AND manifestation_id = ?', daily_count, self.id, manifestation.id]
        ManifestationCheckoutStat.connection.execute(
          self.class.send(:sanitize_sql_array, sql)
        )
      end
    end
    self.completed_at = Time.zone.now
    transition_to!(:completed)
  end
  
  private
  def self.transition_class
    ManifestationCheckoutStatTransition
  end
end

# == Schema Information
#
# Table name: manifestation_checkout_stats
#
#  id           :integer          not null, primary key
#  start_date   :datetime
#  end_date     :datetime
#  note         :text
#  state        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  started_at   :datetime
#  completed_at :datetime
#
