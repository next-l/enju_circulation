class Checkin < ActiveRecord::Base
  scope :on, ->(date) { where('created_at >= ? AND created_at < ?', date.beginning_of_day, date.tomorrow.beginning_of_day) }
  belongs_to :checkout
  belongs_to :librarian, class_name: 'User'
  belongs_to :basket

  before_validation :set_checkout, on: :create
  validate :available_for_checkin?, on: :create
  validates :checkout, presence: true

  attr_accessor :item_identifier

  paginates_per 10

  def set_checkout
    self.checkout = Checkout.not_returned.find_by(item_id: Item.find_by(item_identifier: item_identifier))
  end

  def available_for_checkin?
    return nil unless basket

    unless checkout
      errors[:base] << I18n.t('checkin.item_not_found')
    else
      if checkout.item
        if basket.items.where('item_id = ?', checkout.item_id).first
          errors[:base] << I18n.t('checkin.already_checked_in')
        end
      end
    end
  end

  def item_checkin(current_user)
    message = ''
    Checkin.transaction do
      checkout.item.checkin!
      Checkout.not_returned.where(item_id: checkout.item_id).each do |checkout|
        # TODO: ILL時の処理
        self.checkout = checkout
        checkout.operator = current_user
        unless checkout.user.profile.try(:save_checkout_history)
          checkout.user = nil
        end
        checkout.save(validate: false)
        unless checkout.item.shelf.library == current_user.profile.library
          message << I18n.t('checkin.other_library_item')
        end
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
    message if message.present?
  end
end

# == Schema Information
#
# Table name: checkins
#
#  id           :integer          not null, primary key
#  checkout_id  :uuid             not null
#  librarian_id :integer          not null
#  basket_id    :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  lock_version :integer          default(0), not null
#
