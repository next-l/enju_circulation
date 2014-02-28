class UseRestrictionsController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource :except => [:index, :create]
  authorize_resource :only => [:index, :create]

  def index
    @use_restrictions = UseRestriction.page(params[:page])
  end

  def update
    @use_restriction = UseRestriction.find(params[:id])
    if params[:move]
      move_position(@use_restriction, params[:move])
      return
    end
    update!
  end

  private
  def permitted_params
    params.permit(
      :use_restriction => [:name, :display_name, :note]
    )
  end
end
