def update_checkout
  Checkout.transaction do
    Checkout.find_each do |checkout|
      checkout.update_column(:shelf_id, checkout.item.try(:shelf_id)) if checkout.shelf_id.nil?
      checkout.update_column(:library_id, checkout.librarian.try(:profile).try(:library_id)) if checkout.library_id.nil?
      checkout.checkin.update_column(:checkout_id, checkout.id) if checkout.checkin
    end
  end
end
