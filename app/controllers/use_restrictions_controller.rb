class UseRestrictionsController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource :except => :index
  authorize_resource :only => :index

  def update
    @use_restriction = UseRestriction.find(params[:id])
    if params[:move]
      move_position(@use_restriction, params[:move])
      return
    end
    update!
  end
end
