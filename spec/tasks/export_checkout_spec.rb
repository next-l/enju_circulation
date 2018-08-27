require 'rails_helper'

describe "rake enju_circulation:export:checkout", type: :rake do
  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end
  it "should export necessary fields" do
    $stdout = StringIO.new
    task.execute
    $stdout.rewind
    str = $stdout.read
    $stdout = STDOUT
    csv = CSV.parse(str, {headers: true, col_sep: "\t"})
    csv.each do |row|
      expect(row).to have_key "checked_out_at"
      expect(row["checked_out_at"]).not_to be_blank
      expect(row).to have_key "due_date"
      expect(row["due_date"]).not_to be_blank
      expect(row).to have_key "item_identifier"
      expect(row["item_identifier"]).not_to be_blank
      expect(row).to have_key "call_number"
      expect(row).to have_key "shelf"
      expect(row["shelf"]).not_to be_blank
      expect(row).to have_key "carrier_type"
      expect(row["carrier_type"]).not_to be_blank
      expect(row).to have_key "title"
      expect(row["title"]).not_to be_blank
      expect(row).to have_key "username"
      expect(row["username"]).not_to be_blank
      expect(row).to have_key "full_name"
      expect(row).to have_key "user_number"
      expect(row["user_number"]).not_to be_blank

      expect(row).not_to have_key "checked_in_at"
    end
  end
end
