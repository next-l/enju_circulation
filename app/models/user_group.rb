require_dependency EnjuLibrary::Engine.config.root.join('app', 'models', 'user_group.rb').to_s

class UserGroup < ApplicationRecord
  include EnjuCirculation::EnjuUserGroup
end

# == Schema Information
#
# Table name: user_groups
#
#  id                               :bigint           not null, primary key
#  name                             :string
#  note                             :text
#  position                         :integer
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  valid_period_for_new_user        :integer          default(0), not null
#  expired_at                       :datetime
#  number_of_day_to_notify_overdue  :integer          default(0), not null
#  number_of_day_to_notify_due_date :integer          default(0), not null
#  number_of_time_to_notify_overdue :integer          default(0), not null
#  display_name_translations        :jsonb            not null
#
