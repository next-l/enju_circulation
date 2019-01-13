require 'rails_helper'

describe LendingPolicy do
  # pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: lending_policies
#
#  id             :bigint(8)        not null, primary key
#  item_id        :bigint(8)        not null
#  user_group_id  :bigint(8)        not null
#  loan_period    :integer          default(0), not null
#  fixed_due_date :datetime
#  renewal        :integer          default(0), not null
#  fine           :integer          default(0), not null
#  note           :text
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
