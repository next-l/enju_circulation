class CirculationSweeper < ActionController::Caching::Sweeper
  observe Basket, Checkin, Checkout
  include ExpireEditableFragment

  def after_save(record)
    case
    when record.is_a?(Basket)
      record.checkouts.each do |checkout|
        expire_editable_fragment(checkout.item, ['detail'])
        expire_editable_fragment(checkout.item.manifestation, ['holding', 'show_list'], ['html', 'mobile'])
      end
    when record.is_a?(Checkin)
      expire_editable_fragment(record.item.manifestation, ['holding', 'show_list'], ['html', 'mobile'])
    when record.is_a?(Checkout)
      expire_editable_fragment(record.item.manifestation, ['holding', 'show_list'], ['html', 'mobile'])
    end
  end

  def after_destroy(record)
    after_save(record)
  end
end
