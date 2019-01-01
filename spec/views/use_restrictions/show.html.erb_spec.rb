require 'rails_helper'

describe "use_restrictions/show" do
  before(:each) do
    @use_restriction = assign(:use_restriction, stub_model(UseRestriction,
                                                           name: "Name",
                                                           display_name: "MyText",
                                                           note: "MyText",
                                                           position: 1
    ))
  end

  it "renders attributes in <p>" do
    allow(view).to receive(:policy).and_return double(update?: true)
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
