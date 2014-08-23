class UseRestriction < ActiveRecord::Base
  attr_accessible :name, :display_name, :note
  include MasterModel
  validates :name, presence: true, format: {with: /\A[0-9A-Za-z][0-9A-Za-z_\-\s,]*[0-9a-z]\Z/}

  default_scope {order('use_restrictions.position')}
  scope :available, -> {where(name: ['Not For Loan', 'Limited Circulation, Normal Loan Period'])}
  has_many :item_has_use_restrictions
  has_many :items, through: :item_has_use_restrictions

  private
  def valid_name?
    true
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
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

