class UserReserveStat < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordModel
  include CalculateStat
  default_scope {order('user_reserve_stats.id DESC')}
  scope :not_calculated, -> {in_state(:pending)}
  has_many :reserve_stat_has_users
  has_many :users, :through => :reserve_stat_has_users

  paginates_per 10

  has_many :user_reserve_stat_transitions

  def state_machine
    UserReserveStatStateMachine.new(self, transition_class: UserReserveStatTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
    to: :state_machine

  def calculate_count!
    self.started_at = Time.zone.now
    User.find_each do |user|
      daily_count = user.reserves.created(start_date.beginning_of_day, end_date.tomorrow.beginning_of_day).size
      if daily_count > 0
        self.users << user
        sql = ['UPDATE reserve_stat_has_users SET reserves_count = ? WHERE user_reserve_stat_id = ? AND user_id = ?', daily_count, id, user.id]
        UserReserveStat.connection.execute(
          self.class.send(:sanitize_sql_array, sql)
        )
      end
    end
    self.completed_at = Time.zone.now
    transition_to!(:completed)
  end
  
  private
  def self.transition_class
    UserReserveStatTransition
  end
end

# == Schema Information
#
# Table name: user_reserve_stats
#
#  id           :integer          not null, primary key
#  start_date   :datetime
#  end_date     :datetime
#  note         :text
#  state        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  started_at   :datetime
#  completed_at :datetime
#

