class UserGroupHasCheckoutType < ActiveRecord::Base
  scope :available_for_item, ->(item) { where(checkout_type_id: item.checkout_type.id) }
  scope :available_for_carrier_type, ->(carrier_type) { includes(checkout_type: :carrier_types).where('carrier_types.id' => carrier_type.id) }

  belongs_to :user_group
  belongs_to :checkout_type

  validates_presence_of :user_group, :checkout_type
  validates_associated :user_group, :checkout_type
  validates_uniqueness_of :checkout_type_id, scope: :user_group_id
  validates :checkout_limit, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :checkout_period, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :checkout_renewal_limit, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :reservation_limit, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :reservation_expired_period, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  acts_as_list scope: :user_group_id

end

# == Schema Information
#
# Table name: user_group_has_checkout_types
#
#  id                              :integer          not null, primary key
#  user_group_id                   :uuid             not null
#  checkout_type_id                :integer          not null
#  checkout_limit                  :integer          default(0), not null
#  checkout_period                 :integer          default(0), not null
#  checkout_renewal_limit          :integer          default(0), not null
#  reservation_limit               :integer          default(0), not null
#  reservation_expired_period      :integer          default(7), not null
#  set_due_date_before_closing_day :boolean          default(FALSE), not null
#  fixed_due_date                  :datetime
#  note                            :text
#  position                        :integer
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  current_checkout_count          :integer
#
