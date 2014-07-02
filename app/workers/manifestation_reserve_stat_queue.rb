class ManifestationReserveStatQueue
  def self.perform(manifestation_reserve_stat_id)
    ManifestationReserveStat.find(manifestation_reserve_stat_id).transition_to!(:started)
  end
end
