class Checkin < ActiveRecord::Base
  default_scope { order('checkins.id DESC') }
  scope :on, lambda {|date| where('created_at >= ? AND created_at < ?', date.beginning_of_day, date.tomorrow.beginning_of_day)}
  belongs_to :checkout
  belongs_to :librarian, class_name: 'User'
  belongs_to :basket

  validate :available_for_checkin?, on: :create
  before_validation :set_checkout, on: :create

  attr_accessor :item_identifier

  paginates_per 10

  def available_for_checkin?
    unless basket
      return nil
    end

    unless checkout
      return nil
    end

    if checkout.item.blank?
      errors[:base] << I18n.t('checkin.item_not_found')
      return
    end

    if basket.items.find_by(id: checkout.item_id)
      errors[:base] << I18n.t('checkin.already_checked_in')
    end
  end

  def item_checkin(current_user)
    #return unless item
    message = ''
    Checkin.transaction do
      checkout.item.checkin!
      unless checkout.item.shelf.library == current_user.profile.library
        message << I18n.t('checkin.other_library_item')
      end

      # TODO: ILL時の処理
      update!(checkout: checkout)
      checkout.operator = current_user
      unless checkout.user.profile.try(:save_checkout_history)
        checkout.user = nil
        checkout.save(validate: false)
      end

      if checkout.item.reserved?
        # TODO: もっと目立たせるために別画面を表示するべき？
        message << I18n.t('item.this_item_is_reserved')
        checkout.item.retain(current_user)
      end

      if checkout.item.include_supplements?
        message << I18n.t('item.this_item_include_supplement')
      end

      if checkout.item.circulation_status.name == 'Missing'
        message << I18n.t('checkout.missing_item_found')
      end

      # メールとメッセージの送信
      # ReservationNotifier.deliver_reserved(item.manifestation.reserves.first.user, item.manifestation)
      # Message.create(sender: current_user, receiver: item.manifestation.next_reservation.user, subject: message_template.title, body: message_template.body, recipient: item.manifestation.next_reservation.user)
    end
    if message.present?
      message
    else
      nil
    end
  end

  def set_checkout
    identifier = item_identifier.to_s.strip
    if identifier.present?
      item = Item.find_by(item_identifier: identifier)
      if item
        checkout = Checkout.not_returned.where(item_id: item.id).order(created_at: :desc).first
        self.checkout = checkout
      end
    end
  end
end

# == Schema Information
#
# Table name: checkins
#
#  id           :bigint(8)        not null, primary key
#  librarian_id :bigint(8)
#  basket_id    :bigint(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  lock_version :integer          default(0), not null
#  checkout_id  :bigint(8)        not null
#
