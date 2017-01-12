class ItemHasUseRestriction < ActiveRecord::Base
  belongs_to :item, validate: true
  belongs_to :use_restriction, validate: true
  accepts_nested_attributes_for :use_restriction

  validates_associated :item, :use_restriction
  validates_presence_of :use_restriction
  validates_presence_of :item, on: :update

  paginates_per 10
end

# == Schema Information
#
# Table name: item_has_use_restrictions
#
#  id                 :integer          not null, primary key
#  item_id            :uuid             not null
#  use_restriction_id :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
