# -*- encoding: utf-8 -*-
require 'spec_helper'

describe "profiles/show" do
  fixtures :all

  before(:each) do
    view.stub(:current_user).and_return(User.where(username: 'enjuadmin').first)
    assign(:profile, User.where(username: 'enjuadmin').first.profile)
  end

  it "renders attributes in <p>" do
    allow(view).to receive(:policy).and_return double(update?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Due date/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr:nth-child(2)>td:nth-child(2)", /00014/
  end
end
