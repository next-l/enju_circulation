module EnjuCirculation
  module EnjuBasket
    extend ActiveSupport::Concern

    included do
      has_many :checked_items, dependent: :destroy
      has_many :items, through: :checked_items
      has_many :checkouts
      has_many :checkins
    end

    def basket_checkout(librarian)
      return nil if checked_items.empty?
      Item.transaction do
        checked_items.each do |checked_item|
          checkout = user.checkouts.new
          checkout.librarian = librarian
          checkout.item = checked_item.item
          checkout.shelf = checked_item.item.shelf
          checkout.library = librarian.profile.library
          checkout.due_date = checked_item.due_date
          checked_item.item.circulation_status = CirculationStatus.find_by(name: 'On Loan')
          checked_item.item.save!
          checkout.save!
          if checked_item.item.manifestation.next_reservation
            retain = checked_item.item.retains.order(created_at: :desc).first
            unless retain
              retain = Retain.create!(reserve: checked_item.item.manifestation.next_reservation, item: checked_item.item)
            end
            retain.reserve.transition_to!(:completed)
            RetainAndCheckout.create!(retain: retain, checkout: checkout)
          end
        end
        CheckedItem.where(basket_id: id).destroy_all
      end
    end
  end
end
