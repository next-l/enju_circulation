class CirculationStatusesController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource :except => [:index, :create]
  authorize_resource :only => [:index, :create]

  def index
    @circulation_statuses = CirculationStatus.page(params[:page])
  end

  def update
    @circulation_status = CirculationStatus.find(params[:id])
    if params[:move]
      move_position(@circulation_status, params[:move])
      return
    end
    update!
  end
end
