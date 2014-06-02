require 'spec_helper'

describe "use_restrictions/edit" do
  before(:each) do
    @use_restriction = assign(:use_restriction, stub_model(UseRestriction,
      :name => "MyString",
      :display_name => "MyText",
      :note => "MyText",
      :position => 1
    ))
  end

  it "renders the edit use_restriction form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => use_restrictions_path(@use_restriction), :method => "post" do
      assert_select "input#use_restriction_name", :name => "use_restriction[name]"
      assert_select "textarea#use_restriction_display_name", :name => "use_restriction[display_name]"
      assert_select "textarea#use_restriction_note", :name => "use_restriction[note]"
    end
  end
end
