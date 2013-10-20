class LendingPoliciesController < InheritedResources::Base
  load_and_authorize_resource :except => :index
  authorize_resource :only => :index
  before_action :get_user_group, :get_item
  before_action :prepare_options, :only => [:edit, :update]

  def index
    @lending_policies = LendingPolicy.page(params[:page])
  end

  private
  def prepare_options
    @user_groups = UserGroup.order(:position)
  end
end
