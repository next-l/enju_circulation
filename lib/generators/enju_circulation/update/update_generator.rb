class EnjuCirculation::UpdateGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  desc "Create files for updating Next-L Enju"

  def copy_migration_files
    generate('statesman:add_constraints_to_most_recent', 'Reserve', 'ReserveTransition')
    generate('statesman:add_constraints_to_most_recent', 'ManifestationCheckoutStat', 'ManifestationCheckoutStatTransition')
    generate('statesman:add_constraints_to_most_recent', 'ManifestationReserveStat', 'ManifestationReserveStatTransition')
    generate('statesman:add_constraints_to_most_recent', 'UserCheckoutStat', 'UserCheckoutStatTransition')
    generate('statesman:add_constraints_to_most_recent', 'UserReserveStat', 'UserReserveStatTransition')
  end
end
