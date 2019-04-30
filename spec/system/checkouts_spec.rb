require 'rails_helper'

RSpec.describe 'Checkouts', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all

  describe 'When not logged in', solr: true do
    before(:each) do
      Checkout.reindex
      CarrierType.find_by(name: 'volume').update(attachment: File.open("#{Rails.root.to_s}/app/assets/images/icons/book.png"))
    end

    it 'should contain query params in the facet' do
      sign_in users(:librarian1)
      visit checkouts_path(days_overdue: 10)
      expect(page).to have_link 'RSS', href: checkouts_path(format: :rss, days_overdue: 10)
      expect(page).to have_link 'TSV', href: checkouts_path(format: :txt, days_overdue: 10, locale: 'ja')
    end
  end
end
