class CheckedItemsController < ApplicationController
  load_and_authorize_resource
  before_action :get_basket, :only => [:index, :new, :create, :update]

  # GET /checked_items
  # GET /checked_items.json
  def index
    if @basket
      @checked_items = @basket.checked_items.page(params[:page])
    else
      @checked_items = CheckedItem.page(params[:page])
    end
    @checked_item = CheckedItem.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @checked_items }
      format.js
    end
  end

  # GET /checked_items/1
  # GET /checked_items/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @checked_item }
    end
  end

  # GET /checked_items/new
  # GET /checked_items/new.json
  def new
    unless @basket
      redirect_to new_basket_url
      return
    end
    @checked_item = CheckedItem.new
    @checked_items = @basket.checked_items

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @checked_item }
    end
  end

  # GET /checked_items/1/edit
  def edit
  end

  # POST /checked_items
  # POST /checked_items.json
  def create
    unless @basket
      access_denied; return
    end
    @checked_item.basket = @basket
    @checked_item.librarian = current_user

    flash[:message] = ''

    respond_to do |format|
      if @checked_item.save
        if @checked_item.item.include_supplements
          flash[:message] << t('item.this_item_include_supplement')
        end
        format.html { redirect_to(basket_checked_items_url(@basket), :notice => t('controller.successfully_created', :model => t('activerecord.models.checked_item'))) }
        format.json { render :json => @checked_item, :status => :created, :location => @checked_item }
        format.js { redirect_to(basket_checked_items_url(@basket, :format => :js)) }
      else
        @checked_items = @basket.checked_items
        format.html { render :action => "index" }
        format.json { render :json => @checked_item.errors, :status => :unprocessable_entity }
        format.js { render :action => "index" }
      end
    end
  end

  # PUT /checked_items/1
  # PUT /checked_items/1.json
  def update
    if @basket
      @checked_item = @basket.checked_items.find(params[:id])
    else
      access_denied
      return
    end

    respond_to do |format|
      if @checked_item.update_attributes(params[:checked_item])
        format.html { redirect_to @checked_item, :notice => t('controller.successfully_updated', :model => t('activerecord.models.checked_item')) }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @checked_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /checked_items/1
  # DELETE /checked_items/1.json
  def destroy
    @checked_item.destroy

    respond_to do |format|
      format.html { redirect_to basket_checked_items_url(@checked_item.basket) }
      format.json { head :no_content }
    end
  end
end
