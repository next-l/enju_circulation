require 'rails_helper'

# describe ItemsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe ItemsHelper, type: :helper do
  describe "#circulation_status_facet" do
    it "should respect other params" do
      facet = double(:facet, value: "Available On Shelf", count: 10)
      helper.stub(:filtered_params).and_return(ActionController::Parameters.new(acquired_from: '2012-01-01', controller: "items").permit([:acquired_from, :controller]))
      rendered = helper.circulation_status_facet(facet)
      expect(rendered).to have_link "Available on Shelf (10)", href: "/items?acquired_from=2012-01-01&circulation_status=Available+On+Shelf"
    end
  end
end
