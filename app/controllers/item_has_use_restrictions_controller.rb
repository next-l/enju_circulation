class ItemHasUseRestrictionsController < ApplicationController
  before_action :set_item_has_use_restriction, only: [:show, :edit, :update, :destroy]
  before_action :get_item
  after_action :verify_authorized

  # GET /item_has_use_restrictions
  def index
    authorize ItemHasUseRestriction
    if @item
      @item_has_use_restrictions = @item.item_has_use_restrictions.order('item_has_use_restrictions.id DESC').page(params[:page])
    else
      @item_has_use_restrictions = ItemHasUseRestriction.order('id DESC').page(params[:page])
    end
  end

  # GET /item_has_use_restrictions/1
  def show
  end

  # GET /item_has_use_restrictions/new
  def new
    @item_has_use_restriction = ItemHasUseRestriction.new
    authorize @item_has_use_restriction
    @use_restrictions = UseRestriction.all
  end

  # GET /item_has_use_restrictions/1/edit
  def edit
    @use_restrictions = UseRestriction.all
  end

  # POST /item_has_use_restrictions
  # POST /item_has_use_restrictions.json
  def create
    @item_has_use_restriction = ItemHasUseRestriction.new(item_has_use_restriction_params)
    authorize @item_has_use_restriction

    respond_to do |format|
      if @item_has_use_restriction.save
        format.html { redirect_to @item_has_use_restriction, :notice => t('controller.successfully_created', :model => t('activerecord.models.item_has_use_restriction')) }
        format.json { render :json => @item_has_use_restriction, :status => :created, :location => @item_has_use_restriction }
      else
        @use_restrictions = UseRestriction.all
        format.html { render :action => "new" }
        format.json { render :json => @item_has_use_restriction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /item_has_use_restrictions/1
  # PUT /item_has_use_restrictions/1.json
  def update
    @item_has_use_restriction.assign_attributes(item_has_use_restriction_params)
    respond_to do |format|
      if @item_has_use_restriction.save
        format.html { redirect_to @item_has_use_restriction, :notice => t('controller.successfully_updated', :model => t('activerecord.models.item_has_use_restriction')) }
        format.json { head :no_content }
      else
        @use_restrictions = UseRestriction.all
        format.html { render :action => "edit" }
        format.json { render :json => @item_has_use_restriction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /item_has_use_restrictions/1
  def destroy
    @item_has_use_restriction.destroy
    redirect_to item_has_use_restrictions_url, :notice => t('controller.successfully_destroyed', :model => t('activerecord.models.item_has_use_restriction'))
  end

  private
  def set_item_has_use_restriction
    @item_has_use_restriction = ItemHasUseRestriction.find(params[:id])
    authorize @item_has_use_restriction
  end

  def item_has_use_restriction_params
    params.require(:item_has_use_restriction).permit(
      :item_id, :use_restriction_id
    )
  end
end
