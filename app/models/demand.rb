class Demand < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  belongs_to :message

  validates :item, associated: true, presence: true
  validates :user, associated: true, presence: true
end

# == Schema Information
#
# Table name: demands
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  item_id    :integer
#  message_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
