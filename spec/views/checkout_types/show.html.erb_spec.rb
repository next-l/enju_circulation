require 'rails_helper'

describe "checkout_types/show" do
  before(:each) do
    @checkout_type = assign(:checkout_type, stub_model(CheckoutType,
                                                       name: "Name",
                                                       display_name: "MyText",
                                                       note: "MyText",
                                                       position: 1
    ))
  end

  it "renders attributes in <p>" do
    allow(view).to receive(:policy).and_return double(create?: true, update?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
