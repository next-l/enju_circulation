require 'rails_helper'

describe Manifestation, solr: true do
  fixtures :all

  it "should be reserved" do
    manifestations(:manifestation_00007).is_reserved_by?(users(:admin)).should be_truthy
  end

  it "should not be reserved" do
    manifestations(:manifestation_00007).is_reserved_by?(users(:user1)).should be_falsy
  end

  it "should not be reserved it it has no item" do
    manifestations(:manifestation_00008).is_reservable_by?(users(:admin)).should be_falsy
  end

  it "should not export use_restriction for Guest" do
    manifestation = FactoryBot.create(:manifestation)
    use_restriction = UseRestriction.find(1)
    item = FactoryBot.create(:item, manifestation: manifestation, use_restriction: use_restriction)
    lines = Manifestation.export(role: "Guest")
    csv = CSV.parse(lines, headers: true, col_sep: "\t")
    expect(csv["use_restriction"].compact).to be_empty

    lines = Manifestation.export(role: "Administrator")
    csv = CSV.parse(lines, headers: true, col_sep: "\t")
    expect(csv["use_restriction"].compact).not_to be_empty
  end

  it "should respond to is_checked_out_by?" do
    manifestations(:manifestation_00001).is_checked_out_by?(users(:admin)).should be_truthy
    manifestations(:manifestation_00001).is_checked_out_by?(users(:librarian2)).should be_falsy
  end
end

# == Schema Information
#
# Table name: manifestations
#
#  id                              :integer          not null, primary key
#  original_title                  :text             not null
#  title_alternative               :text
#  title_transcription             :text
#  classification_number           :string
#  manifestation_identifier        :string
#  date_of_publication             :datetime
#  date_copyrighted                :datetime
#  created_at                      :datetime
#  updated_at                      :datetime
#  deleted_at                      :datetime
#  access_address                  :string
#  language_id                     :integer          default(1), not null
#  carrier_type_id                 :integer          default(1), not null
#  start_page                      :integer
#  end_page                        :integer
#  height                          :integer
#  width                           :integer
#  depth                           :integer
#  price                           :integer
#  fulltext                        :text
#  volume_number_string            :string
#  issue_number_string             :string
#  serial_number_string            :string
#  edition                         :integer
#  note                            :text
#  repository_content              :boolean          default(FALSE), not null
#  lock_version                    :integer          default(0), not null
#  required_role_id                :integer          default(1), not null
#  required_score                  :integer          default(0), not null
#  frequency_id                    :integer          default(1), not null
#  subscription_master             :boolean          default(FALSE), not null
#  attachment_file_name            :string
#  attachment_content_type         :string
#  attachment_file_size            :integer
#  attachment_updated_at           :datetime
#  title_alternative_transcription :text
#  description                     :text
#  abstract                        :text
#  available_at                    :datetime
#  valid_until                     :datetime
#  date_submitted                  :datetime
#  date_accepted                   :datetime
#  date_captured                   :datetime
#  pub_date                        :string
#  edition_string                  :string
#  volume_number                   :integer
#  issue_number                    :integer
#  serial_number                   :integer
#  content_type_id                 :integer          default(1)
#  year_of_publication             :integer
#  attachment_meta                 :text
#  month_of_publication            :integer
#  fulltext_content                :boolean
#  serial                          :boolean
#  statement_of_responsibility     :text
#  publication_place               :text
#  extent                          :text
#  dimensions                      :text
#  memo                            :text
#
