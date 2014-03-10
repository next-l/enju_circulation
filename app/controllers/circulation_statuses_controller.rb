class CirculationStatusesController < ApplicationController
  before_action :set_circulation_status, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /circulation_statuses
  def index
    authorize CirculationStatus
    @circulation_statuses = policy_scope(CirculationStatus).order(:position)
  end

  # GET /circulation_statuses/1
  def show
  end

  # GET /circulation_statuses/new
  def new
    @circulation_status = CirculationStatus.new
    authorize @circulation_status
  end

  # GET /circulation_statuses/1/edit
  def edit
  end

  # POST /circulation_statuses
  def create
    @circulation_status = CirculationStatus.new(circulation_status_params)
    authorize @circulation_status

    if @circulation_status.save
      redirect_to @circulation_status, notice:  t('controller.successfully_created', :model => t('activerecord.models.circulation_status'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /circulation_statuses/1
  def update
    if params[:move]
      move_position(@circulation_status, params[:move])
      return
    end
    if @circulation_status.update(circulation_status_params)
      redirect_to @circulation_status, notice:  t('controller.successfully_updated', :model => t('activerecord.models.circulation_status'))
    else
      render action: 'edit'
    end
  end

  # DELETE /circulation_statuses/1
  def destroy
    @circulation_status.destroy
    redirect_to circulation_statuses_url, notice: 'Circulation status was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_circulation_status
      @circulation_status = CirculationStatus.find(params[:id])
      authorize @circulation_status
    end

    # Only allow a trusted parameter "white list" through.
    def circulation_status_params
      params.require(:circulation_status).permit(:name, :display_name, :note)
    end
end
