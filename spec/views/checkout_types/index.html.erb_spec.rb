require 'rails_helper'

describe "checkout_types/index" do
  fixtures :users, :roles, :user_has_roles

  before(:each) do
    view.extend EnjuLeaf::ApplicationHelper

    assign(:checkout_types, Kaminari::paginate_array([
      stub_model(CheckoutType,
                 name: "book",
                 display_name: "Book",
                 note: "MyText",
                 position: 1
      ),
      stub_model(CheckoutType,
                 name: "cd",
                 display_name: "CD",
                 note: "MyText",
                 position: 2
      )
    ]).page(1))
  end

  it "renders a list of checkout_types" do
    allow(view).to receive(:policy).and_return double(create?: true, update?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td:nth-child(3)", /Book/
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td:nth-child(3)", /MyText/
  end
end
