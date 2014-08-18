class CirculationStatusesController < ApplicationController
  load_and_authorize_resource

  # GET /circulation_statuses
  # GET /circulation_statuses.json
  def index
    @circulation_statuses = CirculationStatus.order(:position)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @circulation_statuses }
    end
  end

  # GET /circulation_statuses/1
  # GET /circulation_statuses/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @circulation_status }
    end
  end

  # GET /circulation_statuses/new
  # GET /circulation_statuses/new.json
  def new
    @circulation_status = CirculationStatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @circulation_status }
    end
  end

  # GET /circulation_statuses/1/edit
  def edit
  end

  # POST /circulation_statuses
  # POST /circulation_statuses.json
  def create
    @circulation_status = CirculationStatus.new(params[:circulation_status])

    respond_to do |format|
      if @circulation_status.save
        format.html { redirect_to @circulation_status, notice: t('controller.successfully_created', model: t('activerecord.models.circulation_status')) }
        format.json { render json: @circulation_status, status: :created, location: @circulation_status }
      else
        format.html { render action: "new" }
        format.json { render json: @circulation_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /circulation_statuses/1
  # PUT /circulation_statuses/1.json
  def update
    if params[:move]
      move_position(@circulation_status, params[:move])
      return
    end

    respond_to do |format|
      if @circulation_status.update_attributes(params[:circulation_status])
        format.html { redirect_to @circulation_status, notice: t('controller.successfully_updated', model: t('activerecord.models.circulation_status')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @circulation_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /circulation_statuses/1
  # DELETE /circulation_statuses/1.json
  def destroy
    @circulation_status.destroy

    respond_to do |format|
      format.html { redirect_to circulation_statuses_url }
      format.json { head :no_content }
    end
  end
end
