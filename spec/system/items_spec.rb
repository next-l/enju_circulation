require 'rails_helper'

RSpec.describe 'Items', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all

  describe 'When logged in as Librarian' do
    before do
      sign_in users(:librarian1)
    end

    it 'should show budget_type' do
      visit item_path(items(:item_00001).id, locale: :ja)
      expect(page).to have_content '予算種別'
      expect(page).to have_content '書店'
      expect(page).to have_content '利用制限'
      expect(page).to have_content '購入価格'
    end
  end

  describe 'When logged in as User' do
    before do
      sign_in users(:user1)
    end

    it 'should not show budget_type' do
      visit item_path(items(:item_00001).id, locale: :ja)
      expect(page).not_to have_content '予算種別'
      expect(page).not_to have_content '書店'
      expect(page).not_to have_content '利用制限'
      expect(page).not_to have_content '購入価格'
    end
  end

  describe 'When not logged in' do
    it 'should not show budget_type' do
      visit item_path(items(:item_00001).id, locale: :ja)
      expect(page).not_to have_content '予算種別'
      expect(page).not_to have_content '書店'
      expect(page).not_to have_content '利用制限'
      expect(page).not_to have_content '購入価格'
    end
  end
end
