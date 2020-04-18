require 'rails_helper'

RSpec.describe 'Checkouts', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all

  before(:each) do
    @item = FactoryBot.create(:item)
    @item.use_restriction = UseRestriction.find_by(name: 'Not For Loan')
    @item.save
    CarrierType.find_by(name: 'volume').attachment.attach(io: File.open("#{Rails.root.to_s}/examples/book.png"), filename: 'book.png')
  end

  describe 'When logged in as Librarian' do
    it 'should contain use_restriction' do
      sign_in users(:librarian1)
      visit manifestation_path(@item.manifestation)
      expect(page).to have_content '貸出不可'
    end
  end

  describe 'When not logged in' do
    it 'should contain use_restriction' do
      sign_in users(:librarian1)
      visit manifestation_path(@item.manifestation)
      expect(page).to have_content '貸出不可'
    end
  end
end
