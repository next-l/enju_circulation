require 'rails_helper'

describe "checkout_types/edit" do
  before(:each) do
    @checkout_type = assign(:checkout_type, stub_model(CheckoutType,
      :name => "MyString",
      :display_name => "MyText",
      :note => "MyText",
      :position => 1
    ))
  end

  it "renders the edit checkout_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => checkout_types_path(@checkout_type), :method => "post" do
      assert_select "input#checkout_type_name", :name => "checkout_type[name]"
      assert_select "textarea#checkout_type_display_name", :name => "checkout_type[display_name]"
      assert_select "textarea#checkout_type_note", :name => "checkout_type[note]"
    end
  end
end
