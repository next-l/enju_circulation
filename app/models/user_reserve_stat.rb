class UserReserveStat < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  include CalculateStat
  scope :not_calculated, -> {in_state(:pending)}
  has_many :reserve_stat_has_users
  has_many :users, through: :reserve_stat_has_users
  belongs_to :user

  has_one_attached :attachment
  paginates_per 10
  attr_accessor :mode

  has_many :user_reserve_stat_transitions, autosave: false

  def state_machine
    UserReserveStatStateMachine.new(self, transition_class: UserReserveStatTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
           to: :state_machine

  def calculate_count!
    self.started_at = Time.zone.now
    results = Reserve.where('created_at >= ? AND created_at < ?', start_date.beginning_of_day, end_date.tomorrow.beginning_of_day).group(:user_id).select('user_id, count(user_id)').preload(:user).map{|a| [a.user_id, a.count]}
    results.each do |result|
     ReserveStatHasUser.create(
        user_reserve_stat: self,
        user_id: result[0],
        reserves_count: result[1]
      )
    end
    # attachment.attach(io: StringIO.new(results.to_h.to_json), filename: "result_#{start_date}_#{end_date}.txt")
    self.completed_at = Time.zone.now
    transition_to!(:completed)
    send_message
  end

  private

  def self.transition_class
    UserReserveStatTransition
  end

  def self.initial_state
    :pending
  end
end

# == Schema Information
#
# Table name: user_reserve_stats
#
#  id           :bigint(8)        not null, primary key
#  start_date   :datetime
#  end_date     :datetime
#  note         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  started_at   :datetime
#  completed_at :datetime
#  user_id      :bigint(8)
#
