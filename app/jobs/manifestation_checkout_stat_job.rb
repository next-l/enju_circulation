class ManifestationCheckoutStatJob < ActiveJob::Base
  queue_as :default

  def perform(manifestation_checkout_stat)
    manifestation_checkout_stat.transition_to!(:started)
  end
end
