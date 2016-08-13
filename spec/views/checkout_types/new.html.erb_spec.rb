require 'rails_helper'

describe "checkout_types/new" do
  before(:each) do
    assign(:checkout_type, stub_model(CheckoutType,
      :name => "MyString",
      :display_name => "MyText",
      :note => "MyText",
      :position => 1
    ).as_new_record)
  end

  it "renders new checkout_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => checkout_types_path, :method => "post" do
      assert_select "input#checkout_type_name", :name => "checkout_type[name]"
      assert_select "textarea#checkout_type_display_name", :name => "checkout_type[display_name]"
      assert_select "textarea#checkout_type_note", :name => "checkout_type[note]"
    end
  end
end
