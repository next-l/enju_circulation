class UserReserveStatQueue
  @queue = :user_reserve_stat

  def self.perform(user_reserve_stat_id)
    UserReserveStat.find(user_reserve_stat_id).transition_to!(:started)
  end
end
