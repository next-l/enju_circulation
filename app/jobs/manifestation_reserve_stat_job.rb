class ManifestationReserveStatJob < ActiveJob::Base
  queue_as :default

  def perform(manifestation_reserve_stat)
    manifestation_reserve_stat.transition_to!(:started)
  end
end
