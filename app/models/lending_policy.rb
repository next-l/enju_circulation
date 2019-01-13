class LendingPolicy < ActiveRecord::Base
  default_scope { order('lending_policies.position') }
  belongs_to :item
  belongs_to :user_group

  validates :item, :user_group, presence: true
  validates :user_group_id, uniqueness: { scope: :item_id }
  validates_date :fixed_due_date, allow_blank: true

  paginates_per 10

  acts_as_list scope: :item_id
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
