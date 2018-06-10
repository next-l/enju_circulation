require 'rails_helper'

describe "use_restrictions/index" do
  fixtures :users, :roles, :user_has_roles

  before(:each) do
    view.extend EnjuLeaf::EnjuLeafHelper

    assign(:use_restrictions, Kaminari::paginate_array([
      stub_model(UseRestriction,
        name: "Not For Loan",
        display_name: "Not For Loan",
        note: "MyText",
        position: 1
      ),
      stub_model(UseRestriction,
        name: "On Loan",
        display_name: "On Loan",
        note: "MyText",
        position: 2
      )
    ]).page(1))
  end

  it "renders a list of use_restrictions" do
    allow(view).to receive(:policy).and_return double(create?: true, update?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td:nth-child(3)", /Not For Loan/
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td:nth-child(3)", /MyText/
  end
end
