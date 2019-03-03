require "rails_helper.rb"
require "pundit/rspec"

describe "items/index" do
  before(:each) do
    @items = assign(:items,
      Kaminari.paginate_array( [
        FactoryBot.create(:item),
      ], total_count: 1).page(1)
    )
    facet1 = double("Facet for available on shelf")
    allow(facet1).to receive(:count).and_return(1)
    allow(facet1).to receive(:value).and_return("Available On Shelf")
    @circulation_status_facet = assign(:circulation_status_facet, [facet1])
    user = FactoryBot.create(:librarian)
    allow(view).to receive(:policy) do |record|
      Pundit.policy(user, record)
    end
  end

  describe "circulation_status facet" do
    it "should work with searching acquired_at fields" do
      view.stub(:filtered_params).and_return(ActionController::Parameters.new().permit)
      render
      expect(rendered).to have_selector "div#submenu ul li a"
      expect(rendered).to have_link "Available On Shelf (1)", href: "/items?circulation_status=Available+On+Shelf"
      view.stub(:filtered_params).and_return(ActionController::Parameters.new(acquired_from: '2012-01-01').permit([:acquired_from]))
      render
      expect(rendered).to have_link "Available On Shelf (1)", href: '/items?acquired_from=2012-01-01&circulation_status=Available+On+Shelf'
    end
  end
end

