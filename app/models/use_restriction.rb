class UseRestriction < ActiveRecord::Base
  #include MasterModel
  acts_as_list
  validates :name, :presence => true, :format => {:with => /\A[0-9A-Za-z][0-9A-Za-z_\-\s,]*[0-9a-z]\Z/}
  validates :display_name, :presence => true
  before_validation :set_display_name, :on => :create
  normalize_attributes :name

  default_scope {order('use_restrictions.position')}
  scope :available, -> {where(:name => ['Not For Loan', 'Limited Circulation, Normal Loan Period'])}
  has_many :item_has_use_restrictions
  has_many :items, :through => :item_has_use_restrictions

  def set_display_name
    self.display_name = "#{I18n.locale}: #{name}" if display_name.blank?
  end
end

# == Schema Information
#
# Table name: use_restrictions
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime
#  updated_at   :datetime
#
