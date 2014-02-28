class LendingPoliciesController < InheritedResources::Base
  load_and_authorize_resource :except => [:index, :create]
  authorize_resource :only => [:index, :create]
  before_action :get_user_group, :get_item
  before_action :prepare_options, :only => [:edit, :update]

  def index
    @lending_policies = LendingPolicy.page(params[:page])
  end

  private
  def prepare_options
    @user_groups = UserGroup.order(:position)
  end

  def permitted_params
    params.permit(
      lending_policy: [
        :item_id, :user_group_id, :loan_period, :fixed_due_date,
        :renewal, :fine, :note, :position
      ]
    )
  end
end
