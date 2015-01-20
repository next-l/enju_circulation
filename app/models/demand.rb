class Demand < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  belongs_to :message

  validates :item, associated: true, presence: true
  validates :user, associated: true, presence: true
end
