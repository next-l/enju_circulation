class ManifestationCheckoutStatQueue
  @queue = :enju_leaf

  def self.perform(manifestation_checkout_stat_id)
    ManifestationCheckoutStat.find(manifestation_checkout_stat_id).transition_to!(:started)
  end
end
