class ReserveStatHasManifestationsController < ApplicationController
  before_action :set_reserve_stat_has_manifestation, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /reserve_stat_has_manifestations
  # GET /reserve_stat_has_manifestations.json
  def index
    authorize ReserveStatHasManifestation
    @reserve_stat_has_manifestations = ReserveStatHasManifestation.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reserve_stat_has_manifestations }
    end
  end

  # GET /reserve_stat_has_manifestations/1
  # GET /reserve_stat_has_manifestations/1.json
  def show
  end

  # GET /reserve_stat_has_manifestations/new
  # GET /reserve_stat_has_manifestations/new.json
  def new
    @reserve_stat_has_manifestation = ReserveStatHasManifestation.new
    authorize @reserve_stat_has_manifestation

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reserve_stat_has_manifestation }
    end
  end

  # GET /reserve_stat_has_manifestations/1/edit
  def edit
  end

  # POST /reserve_stat_has_manifestations
  # POST /reserve_stat_has_manifestations.json
  def create
    @reserve_stat_has_manifestation = ReserveStatHasManifestation.new(reserve_stat_has_manifestation_params)
    authorize @reserve_stat_has_manifestation

    respond_to do |format|
      if @reserve_stat_has_manifestation.save
        format.html { redirect_to @reserve_stat_has_manifestation, notice: t('controller.successfully_created', model: t('activerecord.models.reserve_stat_has_manifestation')) }
        format.json { render json: @reserve_stat_has_manifestation, status: :created, location: @reserve_stat_has_manifestation }
      else
        format.html { render action: "new" }
        format.json { render json: @reserve_stat_has_manifestation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reserve_stat_has_manifestations/1
  # PUT /reserve_stat_has_manifestations/1.json
  def update
    @reserve_stat_has_manifestation.assign_attributes(reserve_stat_has_manifestation_params)
    respond_to do |format|
      if @reserve_stat_has_manifestation.save
        format.html { redirect_to @reserve_stat_has_manifestation, notice: t('controller.successfully_updated', model: t('activerecord.models.reserve_stat_has_manifestation')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reserve_stat_has_manifestation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reserve_stat_has_manifestations/1
  # DELETE /reserve_stat_has_manifestations/1.json
  def destroy
    @reserve_stat_has_manifestation.destroy

    respond_to do |format|
      format.html { redirect_to reserve_stat_has_manifestations_url }
      format.json { head :no_content }
    end
  end

  private
  def set_reserve_stat_has_manifestation
    @reserve_stat_has_manifestation = ReserveStatHasManifestation.find(params[:id])
    authorize @reserve_stat_has_manifestation
  end

  def reserve_stat_has_manifestation_params
    params.require(:reserve_stat_has_manifestation).permit(
      :manifestation_reserve_stat_id, :manifestation_id
    )
  end
end
