class LendingPoliciesController < InheritedResources::Base
  load_and_authorize_resource
  before_filter :get_user_group, :get_item
  before_filter :prepare_options, :only => [:edit, :update]

  def index
    @lending_policies = LendingPolicy.page(params[:page])
  end

  private
  def prepare_options
    @user_groups = UserGroup.order(:position)
  end
end
