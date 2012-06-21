class CheckedItem < ActiveRecord::Base
  attr_accessible :item_identifier, :ignore_restriction
  belongs_to :item #, :validate => true
  belongs_to :basket #, :validate => true
  belongs_to :librarian, :class_name => 'User' #, :validate => true

  validates_associated :item, :basket, :on => :update
  validates_presence_of :item, :basket, :due_date, :on => :update
  validates_uniqueness_of :item_id, :scope => :basket_id
  validate :available_for_checkout?, :on => :create
 
  before_validation :set_due_date, :on => :create
  normalize_attributes :item_identifier

  attr_protected :user_id
  attr_accessor :item_identifier, :ignore_restriction

  def available_for_checkout?
    if self.item.blank?
      errors[:base] << I18n.t('activerecord.errors.messages.checked_item.item_not_found')
      return false
    end

    if item.rent?
      errors[:base] << I18n.t('activerecord.errors.messages.checked_item.already_checked_out')
    end

    unless item.available_for_checkout?
      errors[:base] << I18n.t('activerecord.errors.messages.checked_item.not_available_for_checkout')
      return false
    end

    if item_checkout_type.blank?
      errors[:base] << I18n.t('activerecord.errors.messages.checked_item.this_group_cannot_checkout')
      return false
    end
    # ここまでは絶対に貸出ができない場合

    return true if self.ignore_restriction == "1"

    if item.not_for_loan?
      errors[:base] << I18n.t('activerecord.errors.messages.checked_item.not_available_for_checkout')
    end

    if item.reserved?
      if self.item.manifestation.next_reservation.user == self.basket.user
        self.item.manifestation.next_reservation.sm_complete
      else
        errors[:base] << I18n.t('activerecord.errors.messages.checked_item.reserved_item_included')
      end
    end

    checkout_count = basket.user.checked_item_count
    CheckoutType.all.each do |checkout_type|
      #carrier_type = self.item.manifestation.carrier_type
      if checkout_count[:"#{checkout_type.name}"] + self.basket.checked_items.count(:id) >= self.item_checkout_type.checkout_limit
        errors[:base] << I18n.t('activerecord.errors.messages.checked_item.excessed_checkout_limit')
        break
      end
    end
    
    if errors[:base].empty?
      true
    else
      false
    end
  end

  def item_checkout_type
    if item and basket
      basket.user.user_group.user_group_has_checkout_types.available_for_item(item).first
    end
  end

  def set_due_date
    return nil unless self.item_checkout_type

    lending_rule = self.item.lending_rule(self.basket.user)
    return nil if lending_rule.nil?

    if lending_rule.fixed_due_date.blank?
      #self.due_date = item_checkout_type.checkout_period.days.since Time.zone.today
      self.due_date = lending_rule.loan_period.days.since(Time.zone.now).end_of_day
    else
      #self.due_date = item_checkout_type.fixed_due_date
      self.due_date = lending_rule.fixed_due_date.tomorrow.end_of_day
    end
    # 返却期限日が閉館日の場合
    while item.shelf.library.closed?(due_date)
      if item_checkout_type.set_due_date_before_closing_day
        self.due_date = due_date.yesterday.end_of_day
      else
        self.due_date = due_date.tomorrow.end_of_day
      end
    end
    return self.due_date
  end
end

# == Schema Information
#
# Table name: checked_items
#
#  id           :integer         not null, primary key
#  item_id      :integer         not null
#  basket_id    :integer         not null
#  due_date     :datetime        not null
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  librarian_id :integer
#

