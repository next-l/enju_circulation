class UserCheckoutStatQueue
  @queue = :user_checkout_stat

  def self.perform(user_checkout_stat_id)
    UserCheckoutStat.find(user_checkout_stat_id).transition_to!(:started)
  end
end
