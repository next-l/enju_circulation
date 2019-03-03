require 'rails_helper'

describe "manifestations/show" do
  fixtures :all

  before(:each) do
    assign(:manifestation, FactoryBot.create(:manifestation))
    allow(view).to receive(:policy).and_return double(create?: false, udpate?: false, destroy?: false)
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end

  describe "when logged in as Librarian" do
    before(:each) do
      user = assign(:profile, FactoryBot.create(:librarian))
      view.stub(:current_user).and_return(user)
      allow(view).to receive(:policy).and_return double(create?: true, update?: true, destroy?: true)
    end

    it "should have the total number of checkouts" do
      assign(:manifestation, manifestations(:manifestation_00001))
      render
      expect(rendered).to have_css "div.manifestation_total_checkouts", text: /\A\s*.*?: \d+/
    end
  end
end
