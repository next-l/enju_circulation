class ManifestationCheckoutStatQueue
  @queue = :manifestation_checkout_stat

  def self.perform(manifestation_checkout_stat_id)
    ManifestationCheckoutStat.find(manifestation_checkout_stat_id).transition_to!(:started)
  end
end
