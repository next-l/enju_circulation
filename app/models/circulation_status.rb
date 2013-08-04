class CirculationStatus < ActiveRecord::Base
  attr_accessible :name, :display_name, :note
  include MasterModel
  default_scope {order("circulation_statuses.position")}
  scope :available_for_checkout, -> {where(:name => 'Available On Shelf')}
  has_many :items
end

# == Schema Information
#
# Table name: circulation_statuses
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

