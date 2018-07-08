CSV.generate(col_sep: "\t", row_sep: "\r\n") do |csv|
  csv << (%w(username item_identifier title checked_out_at due_date checked_in_at) << "(created_at: #{Time.zone.now})").flatten
  @checkouts.each do |checkout|
    csv << [
      checkout.try(:username),
      checkout.item.item_identifier,
      checkout.item.manifestation.original_title,
      checkout.created_at,
      checkout.due_date,
      checkout.checkin.try(:created_at)
    ]
  end
end
