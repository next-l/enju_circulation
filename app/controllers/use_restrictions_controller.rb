class UseRestrictionsController < ApplicationController
  before_action :set_use_restriction, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /use_restrictions
  def index
    authorize UseRestriction
    @use_restrictions = policy_scope(UseRestriction).order(:position)
  end

  # GET /use_restrictions/1
  def show
  end

  # GET /use_restrictions/new
  def new
    @use_restriction = UseRestriction.new
    authorize @use_restriction
  end

  # GET /use_restrictions/1/edit
  def edit
  end

  # POST /use_restrictions
  def create
    @use_restriction = UseRestriction.new(use_restriction_params)
    authorize @use_restriction

    if @use_restriction.save
      redirect_to @use_restriction, notice:  t('controller.successfully_created', :model => t('activerecord.models.use_restriction'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /use_restrictions/1
  def update
    if params[:move]
      move_position(@use_restriction, params[:move])
      return
    end
    if @use_restriction.update(use_restriction_params)
      redirect_to @use_restriction, notice:  t('controller.successfully_updated', :model => t('activerecord.models.use_restriction'))
    else
      render action: 'edit'
    end
  end

  # DELETE /use_restrictions/1
  def destroy
    @use_restriction.destroy
    redirect_to use_restrictions_url, :notice => t('controller.successfully_destroyed', :model => t('activerecord.models.use_restriction'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_use_restriction
      @use_restriction = UseRestriction.find(params[:id])
      authorize @use_restriction
    end

    # Only allow a trusted parameter "white list" through.
    def use_restriction_params
      params.require(:use_restriction).permit(:name, :display_name, :note)
    end
end
