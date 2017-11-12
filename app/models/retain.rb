class Retain < ApplicationRecord
  belongs_to :reserve
  belongs_to :item
  has_one :retain_and_checkout
  has_one :checkout, through: :retain_and_checkout

  def send_message(sender = nil)
    message_template_for_patron = MessageTemplate.localized_template('item_received_for_patron', reserve.user.profile.locale)
    request = MessageRequest.new
    request.assign_attributes(sender: sender, receiver: reserve.user, message_template: message_template_for_patron)
    request.save_message_body(manifestations: Array[item.manifestation], user: reserve.user)
    request.transition_to!(:sent)
    message_template_for_library = MessageTemplate.localized_template('item_received_for_library', reserve.user.profile.locale)
    request = MessageRequest.new
    request.assign_attributes(sender: sender, receiver: sender, message_template: message_template_for_library)
    request.save_message_body(manifestations: Array[item.manifestation], user: reserve.user)
    request.transition_to!(:sent)
  end
end

# == Schema Information
#
# Table name: retains
#
#  id         :integer          not null, primary key
#  reserve_id :uuid             not null
#  item_id    :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
