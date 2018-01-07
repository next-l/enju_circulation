class AddConstraintsToMostRecentForManifestationReserveStatTransitions < ActiveRecord::Migration
  disable_ddl_transaction!

  def up
    add_index :manifestation_reserve_stat_transitions, [:manifestation_reserve_stat_id, :most_recent], unique: true, where: "most_recent", name: "index_manifestation_reserve_stat_transitions_parent_most_recent" #, algorithm: :concurrently
    change_column_null :manifestation_reserve_stat_transitions, :most_recent, false
  end

  def down
    remove_index :manifestation_reserve_stat_transitions, name: "index_manifestation_reserve_stat_transitions_parent_most_recent"
    change_column_null :manifestation_reserve_stat_transitions, :most_recent, true
  end
end
