require 'spec_helper'

describe "reserves/index" do
  fixtures :users, :roles, :user_has_roles, :reserves

  before(:each) do
    assign(:reserves, Reserve.page(1))
    view.stub(:current_user).and_return(User.where(username: 'enjuadmin').first)
  end

  it "renders a list of reserves" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td:nth-child(1)", :text => reserves(:reserve_00001).id.to_s
    assert_select "tr>td:nth-child(2)", :text => /#{reserves(:reserve_00001).user.username}/
    assert_select "tr>td:nth-child(2)", :text => /#{reserves(:reserve_00002).manifestation.original_title}/
  end
end
