require 'rails_helper'

RSpec.describe 'Manifestations', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all
  before do
    @item = FactoryBot.create(:item, circulation_status: CirculationStatus.find_by(name: 'Available On Shelf'), shelf: shelves(:shelf_00002))
    @removed_item = FactoryBot.create(:item, circulation_status: CirculationStatus.find_by(name: 'Removed'), shelf: shelves(:shelf_00002))
    FactoryBot.create(:withdraw, item: @item)
  end

  describe 'When logged in as Librarian' do
    before do
      sign_in users(:librarian1)
    end

    it 'should show removed item' do
      visit manifestation_path(@removed_item.manifestation.id, locale: :ja)
      expect(page).to have_content @removed_item.manifestation.items.first.item_identifier
    end

    it 'should show withdrawn item' do
      visit manifestation_path(@item.manifestation.id, locale: :ja)
      expect(page).to have_content @item.item_identifier
    end
  end

  describe 'When logged in as User' do
    before do
      sign_in users(:user1)
    end

    it 'should not show removed item' do
      visit manifestation_path(@removed_item.manifestation.id, locale: :ja)
      expect(page).not_to have_content @removed_item.manifestation.items.first.item_identifier
    end

    it 'should not show withdrawn item' do
      visit manifestation_path(@item.manifestation.id, locale: :ja)
      expect(page).not_to have_content @item.item_identifier
    end
  end

  describe 'When not logged in' do
    it 'should not show removed item' do
      visit manifestation_path(@removed_item.manifestation.id, locale: :ja)
      expect(page).not_to have_content @removed_item.manifestation.items.first.item_identifier
    end

    it 'should not show withdrawn item' do
      visit manifestation_path(@item.manifestation.id, locale: :ja)
      expect(page).not_to have_content @item.item_identifier
    end
  end
end