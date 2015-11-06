# -*- encoding: utf-8 -*-
require 'spec_helper'

describe "checkouts/index" do
  fixtures :all

  before(:each) do
    view.extend EnjuLeaf::EnjuLeafHelper
    view.extend EnjuBiblio::BiblioHelper

    assign(:checkouts, Checkout.page(1))
    assign(:checkouts_facet, [])
    view.stub(:current_user).and_return(User.where(username: 'enjuadmin').first)
  end

  it "renders a list of checkouts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr:nth-child(2)>td:nth-child(2)", /00001/
  end
end
