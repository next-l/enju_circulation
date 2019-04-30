class ManifestationCheckoutStatJob < ActiveJob::Base
  queue_as :enju_leaf

  def perform(manifestation_checkout_stat)
    manifestation_checkout_stat.transition_to!(:started)
    manifestation_checkout_stat.transition_to!(:completed)
  end
end
