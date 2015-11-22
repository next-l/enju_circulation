class UserReserveStatJob < ActiveJob::Base
  queue_as :default

  def perform(user_reserve_stat)
    user_reserve_stat.transition_to!(:started)
  end
end
