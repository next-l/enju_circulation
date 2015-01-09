class Demand < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  belongs_to :message
end
