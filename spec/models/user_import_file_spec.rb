require 'rails_helper'

describe UserImportFile do
  fixtures :all

  describe "when its mode is 'create'" do
    it "should be imported" do
      file = UserImportFile.create(
        default_user_group: UserGroup.find(2),
        default_library: Library.find(3),
        user: users(:admin)
      )
      file.attachment.attach(io: File.new("#{Rails.root}/../../examples/user_import_file_sample.tsv"), filename: 'attachment.txt')
      old_users_count = User.count
      old_import_results_count = UserImportResult.count
      file.current_state.should eq 'pending'
      file.import_start.should eq({user_imported: 5, user_found: 0, failed: 0, error: 3})
      user003 = User.find_by(username: 'user003')
      user003.profile.checkout_icalendar_token.should eq 'secrettoken'
      user003.profile.save_checkout_history.should be_truthy
    end
  end

  describe "when its mode is 'destroy'" do
    it "should not remove users" do
      file = UserImportFile.create(
        default_user_group: UserGroup.find(2),
        default_library: Library.find(3),
        user: users(:admin)
      )
      file.attachment.attach(io: File.new("#{Rails.root}/../../examples/user_delete_file.tsv"), filename: 'attachment.txt')
      old_count = User.count
      old_message_count = Message.count
      file.remove
      User.count.should eq old_count - 2
      Message.count.should eq old_message_count + 1
    end

    it "should not remove users if there are checkouts" do
      file1 = UserImportFile.create(
        default_user_group: UserGroup.find(2),
        default_library: Library.find(3),
        user: users(:admin)
      )
      file1.attachment.attach(io: File.new("#{Rails.root}/../../examples/user_import_file_sample.tsv"), filename: 'attachment.txt')
      file1.import_start

      user001 = User.find_by(username: 'user001')
      FactoryBot.create(:checkout, user: user001, item: FactoryBot.create(:item))
      old_count = User.count
      file2 = UserImportFile.create!(
        user: users(:admin),
        default_user_group: UserGroup.find(2),
        default_library: Library.find(3)
      )
      file2.attachment.attach(io: File.new("#{Rails.root}/../../examples/user_delete_file.tsv"), filename: 'attachment.txt')
      file2.remove
      User.where(username: 'user001').should_not be_blank
      User.count.should eq old_count - 2
    end
  end
end

# == Schema Information
#
# Table name: user_import_files
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  note                     :text
#  executed_at              :datetime
#  user_import_file_name    :string
#  user_import_content_type :string
#  user_import_file_size    :integer
#  user_import_updated_at   :datetime
#  user_import_fingerprint  :string
#  edit_mode                :string
#  error_message            :text
#  created_at               :datetime
#  updated_at               :datetime
#  user_encoding            :string
#  default_library_id       :integer
#  default_user_group_id    :integer
#
