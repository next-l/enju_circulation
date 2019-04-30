class ManifestationReserveStatJob < ActiveJob::Base
  queue_as :enju_leaf

  def perform(manifestation_reserve_stat)
    manifestation_reserve_stat.transition_to!(:started)
    manifestation_reserve_stat.transition_to!(:completed)
  end
end
