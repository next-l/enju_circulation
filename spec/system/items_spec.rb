require 'rails_helper'

RSpec.describe 'Checkouts', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all

  before(:each) do
    CarrierType.find_by(name: 'volume').update(attachment: File.open("#{Rails.root.to_s}/app/assets/images/icons/book.png"))
  end

  describe 'When logged in as Librarian' do
    it 'should not set "Removed" as circulation status if the item is reserved' do
      item = FactoryBot.create(:reserve).item
      sign_in users(:librarian1)
      visit edit_item_path(item)
      select('除籍済み', from: 'item_circulation_status_id')
      click_button('更新する')
      expect(page).to have_content 'この貸出状態には変更できません。資料が予約されています。'
    end
  end
end
