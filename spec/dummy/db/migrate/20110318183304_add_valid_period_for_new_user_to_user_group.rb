class AddValidPeriodForNewUserToUserGroup < ActiveRecord::Migration[5.1]
  def change
    add_column :user_groups, :valid_period_for_new_user, :integer, :default => 0, :null => false
    add_column :user_groups, :expired_at, :timestamp
  end
end
