require 'rails_helper'

RSpec.describe 'ManifestationCheckoutStats', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all

  describe 'When logged in as Librarian' do
    before do
      sign_in users(:librarian1)
    end

    it 'should show checkout stat' do
      stat = ManifestationCheckoutStat.create(
        user: users(:librarian1),
        start_date: '2007-01-01',
        end_date: '2010-12-31'
      )
      visit manifestation_checkout_stat_path(stat)
      expect(page).to have_content '10'
    end
  end
end
