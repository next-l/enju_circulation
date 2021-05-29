require 'rails_helper'

describe "manifestations/show" do
  fixtures :all

  before(:each) do
    assign(:manifestation, FactoryBot.create(:item).manifestation)
    allow(view).to receive(:policy).and_return double(create?: false, udpate?: false, destroy?: false)
  end

  describe "when logged in as Librarian" do
    before(:each) do
      user = assign(:profile, FactoryBot.create(:librarian))
      view.stub(:current_user).and_return(user)
      allow(view).to receive(:policy).and_return double(show?: true, create?: true, update?: true, destroy?: true)
    end

    it "should have the total number of checkouts" do
      render
      expect(rendered).to have_css "div.manifestation_total_checkouts", text: /\A\s*.*?: \d+/
    end
  end
end
