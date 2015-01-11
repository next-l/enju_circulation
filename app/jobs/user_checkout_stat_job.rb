class UserCheckoutStatJob < ActiveJob::Base
  queue_as :default

  def perform(user_checkout_stat)
    user_checkout_stat.transition_to!(:started)
  end
end
