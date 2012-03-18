class CirculationSweeper < ActionController::Caching::Sweeper
  observe Basket, Checkin, Checkout
  include ExpireEditableFragment

  def after_save(record)
    case
    when record.is_a?(Basket)
      record.checkouts.each do |checkout|
        expire_editable_fragment(checkout.item)
        expire_editable_fragment(checkout.item.manifestation)
      end
    when record.is_a?(Checkin)
      expire_editable_fragment(record.item.manifestation)
    when record.is_a?(Checkout)
      expire_editable_fragment(record.item.manifestation)
    end
  end

  def after_destroy(record)
    after_save(record)
  end
end
