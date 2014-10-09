class LendingPoliciesController < ApplicationController
  before_action :set_lending_policy, only: [:show, :edit, :update, :destroy]
  before_action :get_user_group, :get_item
  before_action :prepare_options, only: [:edit, :update]
  after_action :verify_authorized

  # GET /lending_policies
  # GET /lending_policies.json
  def index
    authorize LendingPolicy
    @lending_policies = LendingPolicy.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lending_policies }
    end
  end

  # GET /lending_policies/1
  # GET /lending_policies/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lending_policy }
    end
  end

  # GET /lending_policies/new
  # GET /lending_policies/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lending_policy }
    end
  end

  # GET /lending_policies/1/edit
  def edit
  end

  # POST /lending_policies
  # POST /lending_policies.json
  def create
    respond_to do |format|
      if @lending_policy.save
        format.html { redirect_to @lending_policy, notice: t('controller.successfully_created', model: t('activerecord.models.lending_policy')) }
        format.json { render json: @lending_policy, status: :created, location: @lending_policy }
      else
        prepare_options
        format.html { render action: "new" }
        format.json { render json: @lending_policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lending_policies/1
  # PUT /lending_policies/1.json
  def update
    respond_to do |format|
      if @lending_policy.update_attributes(params[:lending_policy])
        format.html { redirect_to @lending_policy, notice: t('controller.successfully_updated', model: t('activerecord.models.lending_policy')) }
        format.json { head :no_content }
      else
        prepare_options
        format.html { render action: "edit" }
        format.json { render json: @lending_policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lending_policies/1
  # DELETE /lending_policies/1.json
  def destroy
    @lending_policy.destroy

    respond_to do |format|
      format.html { redirect_to lending_policies_url }
      format.json { head :no_content }
    end
  end

  # GET /lending_policies/1
  def show
  end

  # GET /lending_policies/new
  def new
    @lending_policy = LendingPolicy.new
    authorize @lending_policy
  end

  # GET /lending_policies/1/edit
  def edit
  end

  # POST /lending_policies
  def create
    @lending_policy = LendingPolicy.new(lending_policy_params)
    authorize @lending_policy

    if @lending_policy.save
      redirect_to @lending_policy, notice: t('controller.successfully_created', model: t('activerecord.models.lending_policy'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /lending_policies/1
  def update
    if params[:move]
      move_position(@lending_policy, params[:move])
      return
    end
    if @lending_policy.update(lending_policy_params)
      redirect_to @lending_policy, notice: t('controller.successfully_updated', model: t('activerecord.models.lending_policy'))
    else
      render action: 'edit'
    end
  end

  # DELETE /lending_policies/1
  def destroy
    @lending_policy.destroy
    redirect_to lending_policies_url, notice: 'Lending policy was successfully destroyed.'
  end

  private
  def set_lending_policy
    @lending_policy = LendingPolicy.find(params[:id])
    authorize @lending_policy
  end

  def lending_policy_params
    params.require(:lending_policy).permit(
      :item_id, :user_group_id, :loan_period, :fixed_due_date,
      :renewal, :fine, :note, :position
    )
  end

  def prepare_options
    @user_groups = UserGroup.order(:position)
  end
end
