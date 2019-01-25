require 'rails_helper'

describe UserImportFile do
  fixtures :all

  describe "when its mode is 'create'" do
    before(:each) do
      @file = UserImportFile.create!(
        user_import: File.new("#{Rails.root}/../../examples/user_import_file_sample.tsv"),
        default_user_group: user_groups(:user_group_00002),
        default_library: libraries(:library_00003),
        user: users(:admin)
      )
    end

    it "should be imported" do
      file = UserImportFile.create!(
        user_import: File.new("#{Rails.root}/../../examples/user_import_file_sample.tsv"),
        default_user_group: user_groups(:user_group_00002),
        default_library: libraries(:library_00003),
        user: users(:admin)
      )
      old_users_count = User.count
      old_import_results_count = UserImportResult.count
      file.current_state.should eq 'pending'
      file.import_start.should eq({user_imported: 5, user_found: 0, failed: 0, error: 3})
      User.order('id DESC')[1].username.should eq 'user005'
      User.order('id DESC')[2].username.should eq 'user003'
      User.count.should eq old_users_count + 5

      user001 = User.where(username: 'user001').first
      user001.profile.keyword_list.should eq "日本史\n地理"
      user001.profile.full_name.should eq '田辺 浩介'
      user001.profile.full_name_transcription.should eq 'たなべ こうすけ'
      user001.profile.required_role.name.should eq 'User'
      user001.locked_at.should be_truthy

      user002 = User.where(username: 'user002').first
      user002.profile.user_group.name.should eq 'faculty'
      user002.profile.expired_at.to_i.should eq Time.zone.parse('2013-12-01').end_of_day.to_i
      user002.valid_password?('4NsxXPLy')
      user002.profile.user_number.should eq '001002'
      user002.profile.library.name.should eq 'hachioji'
      user002.profile.locale.should eq 'en'
      user002.profile.required_role.name.should eq 'Librarian'
      user002.locked_at.should be_nil

      user003 = User.where(username: 'user003').first
      user003.profile.note.should eq 'テストユーザ'
      user003.role.name.should eq 'Librarian'
      user003.profile.user_number.should eq '001003'
      user003.profile.library.name.should eq 'kamata'
      user003.profile.locale.should eq 'ja'
      user003.profile.checkout_icalendar_token.should eq 'secrettoken'
      user003.profile.save_checkout_history.should be_truthy
      # user003.profile.save_search_history.should be_falsy
      # user003.profile.share_bookmarks.should be_falsy
      User.where(username: 'user000').first.should be_nil
      UserImportResult.count.should eq old_import_results_count + 10
      UserImportResult.order('id DESC')[0].error_message.should eq "line 10: Profile must exist Profile can't be blank User number has already been taken"
      UserImportResult.order('id DESC')[1].error_message.should eq "line 9: Profile must exist Profile can't be blank User number is invalid"
      UserImportResult.order('id DESC')[2].error_message.should eq 'line 8: Password is too short (minimum is 6 characters)'

      user005 = User.where(username: 'user005').first
      user005.role.name.should eq 'User'
      user005.profile.library.name.should eq 'hachioji'
      user005.profile.locale.should eq 'en'
      user005.profile.user_number.should eq '001005'
      user005.profile.user_group.name.should eq 'faculty'

      user006 = User.where(username: 'user006').first
      user006.role.name.should eq 'User'
      user006.profile.library.name.should eq 'hachioji'
      user006.profile.locale.should eq 'en'
      user006.profile.user_number.should be_nil
      user006.profile.user_group.name.should eq user_groups(:user_group_00002).name

      file.user_import_fingerprint.should be_truthy
      file.executed_at.should be_truthy

      file.reload
      file.error_message.should eq "The following column(s) were ignored: save_search_history, share_bookmarks, invalid\nline 8: Password is too short (minimum is 6 characters)\nline 9: Profile must exist Profile can't be blank User number is invalid\nline 10: Profile must exist Profile can't be blank User number has already been taken"
      file.current_state.should eq 'failed'
    end
  end

  describe "when its mode is 'destroy'" do
    before(:each) do
      file = UserImportFile.create!(
        user_import: File.new("#{Rails.root}/../../examples/user_import_file_sample.tsv"),
        user: users(:admin),
        default_user_group: user_groups(:user_group_00002),
        default_library: libraries(:library_00003)
      )
      file.import_start
    end

    it "should not remove users if there are checkouts" do
      user001 = User.find_by(username: 'user001')
      FactoryBot.create(:checkout, user: user001, item: FactoryBot.create(:item))
      old_count = User.count
      file = UserImportFile.create!(
        user_import: File.new("#{Rails.root}/../../examples/user_delete_file.tsv"),
        default_user_group: user_groups(:user_group_00002),
        default_library: libraries(:library_00003),
        user: users(:admin)
      )
      file.remove
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
