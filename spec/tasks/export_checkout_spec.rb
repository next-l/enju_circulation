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
        %w[ checked_out_at checked_in_at item_identifier call_number shelf carrier_type title username full_name ].each do |c|
          expect(row).to have_key c
        end
      end
  end
end
