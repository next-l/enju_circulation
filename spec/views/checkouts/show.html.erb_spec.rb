require 'spec_helper'

describe "checkouts/show" do
  fixtures :checkouts, :users, :user_has_roles, :roles

  before(:each) do
    @checkout = assign(:checkout, stub_model(Checkout,
      user_id: 2,
      item_id: 1
    ))
    view.stub(:current_user).and_return(User.where(username: 'enjuadmin').first)
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Due date/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Current user/)
  end
end
