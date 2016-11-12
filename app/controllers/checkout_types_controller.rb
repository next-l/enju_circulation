class CheckoutTypesController < ApplicationController
  before_action :set_checkout_type, only: [:show, :edit, :update, :destroy]
  before_action :check_policy, only: [:index, :new, :create]
  before_action :get_user_group

  # GET /checkout_types
  # GET /checkout_types.json
  def index
    @checkout_types = if @user_group
                        @user_group.checkout_types.order('checkout_types.position')
                      else
                        CheckoutType.order(:position)
                      end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @checkout_types }
    end
  end

  # GET /checkout_types/1
  # GET /checkout_types/1.json
  def show
    @checkout_type = @user_group.checkout_types.find(params[:id]) if @user_group

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @checkout_type }
    end
  end

  # GET /checkout_types/new
  # GET /checkout_types/new.json
  def new
    @checkout_type = if @user_group
                       @user_group.checkout_types.new
                     else
                       CheckoutType.new
                     end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @checkout_type }
    end
  end

  # GET /checkout_types/1/edit
  def edit
  end

  # POST /checkout_types
  # POST /checkout_types.json
  def create
    @checkout_type = if @user_group
                       @user_group.checkout_types.new(checkout_type_params)
                     else
                       CheckoutType.new(checkout_type_params)
                     end

    respond_to do |format|
      if @checkout_type.save
        format.html { redirect_to @checkout_type, notice: t('controller.successfully_created', model: t('activerecord.models.checkout_type')) }
        format.json { render json: @checkout_type, status: :created, location: @checkout_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @checkout_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /checkout_types/1
  # PUT /checkout_types/1.json
  def update
    if params[:move]
      move_position(@checkout_type, params[:move])
      return
    end

    respond_to do |format|
      if @checkout_type.update_attributes(checkout_type_params)
        format.html { redirect_to @checkout_type, notice: t('controller.successfully_updated', model: t('activerecord.models.checkout_type')) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @checkout_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /checkout_types/1
  # DELETE /checkout_types/1.json
  def destroy
    @checkout_type = @user_group.checkout_types.find(params[:id]) if @user_group
    @checkout_type.destroy

    respond_to do |format|
      format.html { redirect_to checkout_types_url }
      format.json { head :no_content }
    end
  end

  private

  def set_checkout_type
    @checkout_type = CheckoutType.find(params[:id])
    authorize @checkout_type
    access_denied unless LibraryGroup.site_config.network_access_allowed?(request.ip)
  end

  def check_policy
    authorize CheckoutType
  end

  def checkout_type_params
    params.require(:checkout_type).permit(:name, :display_name, :note)
  end
end
