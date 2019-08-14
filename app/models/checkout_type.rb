class CheckoutType < ApplicationRecord
  include MasterModel
  scope :available_for_carrier_type, lambda {|carrier_type| includes(:carrier_types).where('carrier_types.name = ?', carrier_type.name).order('carrier_types.position')}
  scope :available_for_user_group, lambda {|user_group| includes(:user_groups).where('user_groups.name = ?', user_group.name).order('user_group.position')}

  has_many :user_group_has_checkout_types, dependent: :destroy
  has_many :user_groups, through: :user_group_has_checkout_types
  has_many :carrier_type_has_checkout_types, dependent: :destroy
  has_many :carrier_types, through: :carrier_type_has_checkout_types
  # has_many :item_has_checkout_types, dependent: :destroy
  # has_many :items, through: :item_has_checkout_types
  has_many :items

  paginates_per 10
  translates :display_name
end

# == Schema Information
#
# Table name: checkout_types
#
#  id                        :integer          not null, primary key
#  name                      :string           not null
#  display_name              :text
#  note                      :text
#  position                  :integer
#  created_at                :datetime
#  updated_at                :datetime
#  display_name_translations :jsonb            not null
#
