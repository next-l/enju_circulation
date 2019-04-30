class ManifestationReserveStatsController < ApplicationController
  before_action :set_manifestation_reserve_stat, only: [:show, :edit, :update, :destroy]
  before_action :check_policy, only: [:index, :new, :create]
  after_action :convert_charset, only: :show
  after_action :convert_charset, only: :show

  # GET /manifestation_reserve_stats
  # GET /manifestation_reserve_stats.json
  def index
    @manifestation_reserve_stats = ManifestationReserveStat.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @manifestation_reserve_stats }
    end
  end

  # GET /manifestation_reserve_stats/1
  # GET /manifestation_reserve_stats/1.json
  def show
    if params[:format] == 'txt'
      per_page = 65534
    else
      per_page = 10
    end

    @carrier_type_results = Reserve.where(
      Reserve.arel_table[:created_at].gteq @manifestation_reserve_stat.start_date
    ).where(
      Reserve.arel_table[:created_at].lt @manifestation_reserve_stat.end_date
    ).joins(item: :manifestation).group(
      :carrier_type_id
    ).merge(
      Manifestation.where(carrier_type_id: CarrierType.pluck(:id))
    ).count(:id)

    @checkout_type_results = Reserve.where(
      Reserve.arel_table[:created_at].gteq @manifestation_reserve_stat.start_date
    ).where(
      Reserve.arel_table[:created_at].lt @manifestation_reserve_stat.end_date
    ).joins(item: :manifestation).group(
      :checkout_type_id
    ).count(:id)

    @stats = Reserve.where(
      Reserve.arel_table[:created_at].gteq @manifestation_reserve_stat.start_date
    ).where(
      Reserve.arel_table[:created_at].lt @manifestation_reserve_stat.end_date
    ).joins(item: :manifestation).group(:manifestation_id).merge(
      Manifestation.where(carrier_type_id: CarrierType.pluck(:id))
    ).order('count_id DESC').page(params[:page]).per(per_page)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manifestation_reserve_stat }
      format.txt
    end
  end

  # GET /manifestation_reserve_stats/new
  # GET /manifestation_reserve_stats/new.json
  def new
    @manifestation_reserve_stat = ManifestationReserveStat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manifestation_reserve_stat }
    end
  end

  # GET /manifestation_reserve_stats/1/edit
  def edit
  end

  # POST /manifestation_reserve_stats
  # POST /manifestation_reserve_stats.json
  def create
    @manifestation_reserve_stat = ManifestationReserveStat.new(manifestation_reserve_stat_params)
    @manifestation_reserve_stat.user = current_user

    respond_to do |format|
      if @manifestation_reserve_stat.save
        ManifestationReserveStatJob.perform_later(@manifestation_reserve_stat)
        format.html { redirect_to @manifestation_reserve_stat, notice: t('statistic.successfully_created', model: t('activerecord.models.manifestation_reserve_stat')) }
        format.json { render json: @manifestation_reserve_stat, status: :created, location: @manifestation_reserve_stat }
      else
        format.html { render action: "new" }
        format.json { render json: @manifestation_reserve_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manifestation_reserve_stats/1
  # PUT /manifestation_reserve_stats/1.json
  def update
    respond_to do |format|
      if @manifestation_reserve_stat.update(manifestation_reserve_stat_params)
        if @manifestation_reserve_stat.mode == 'import'
          ManifestationReserveStatJob.perform_later(@manifestation_reserve_stat)
        end
        format.html { redirect_to @manifestation_reserve_stat, notice: t('controller.successfully_created', model: t('activerecord.models.manifestation_reserve_stat')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @manifestation_reserve_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manifestation_reserve_stats/1
  # DELETE /manifestation_reserve_stats/1.json
  def destroy
    @manifestation_reserve_stat.destroy

    respond_to do |format|
      format.html { redirect_to manifestation_reserve_stats_url }
      format.json { head :no_content }
    end
  end

  private

  def set_manifestation_reserve_stat
    @manifestation_reserve_stat = ManifestationReserveStat.find(params[:id])
    authorize @manifestation_reserve_stat
  end

  def check_policy
    authorize ManifestationReserveStat
  end

  def manifestation_reserve_stat_params
    params.require(:manifestation_reserve_stat).permit(
      :start_date, :end_date, :note, :mode
    )
  end
end
