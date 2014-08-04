class CirculationStatus < ActiveRecord::Base
  attr_accessible :name, :display_name, :note
  #include MasterModel
  acts_as_list
  validates :name, :presence => true, :format => {:with => /\A[0-9A-Za-z][0-9A-Za-z_\-\s,]*[0-9a-z]\Z/}
  validates :display_name, :presence => true
  before_validation :set_display_name, :on => :create
  normalize_attributes :name

  default_scope :order => "circulation_statuses.position"
  scope :available_for_checkout, where(:name => 'Available On Shelf')
  has_many :items

  def set_display_name
    self.display_name = "#{I18n.locale}: #{name}" if display_name.blank?
  end
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

