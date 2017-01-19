class Retain < ApplicationRecord
  belongs_to :reserve
  belongs_to :item
end

# == Schema Information
#
# Table name: retains
#
#  id         :integer          not null, primary key
#  reserve_id :uuid             not null
#  item_id    :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
