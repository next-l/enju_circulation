require 'rails_helper'

describe "checkouts/show" do
  fixtures :checkouts, :users, :user_has_roles, :roles, :profiles

  before(:each) do
    @checkout = assign(:checkout, stub_model(Checkout,
      user_id: 2,
      item_id: 1
    ))
    assign(:library_group, LibraryGroup.site_config)
    I18n.locale = :en
    view.stub(:current_user).and_return(User.where(username: 'enjuadmin').first)
  end

  it "renders attributes in <p>" do
    allow(view).to receive(:policy).and_return double(update?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Due date/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Item identifier/)
  end
end
