class CheckinsController < ApplicationController
  load_and_authorize_resource :except => :index
  authorize_resource :only => :index
  before_filter :get_user
  before_filter :get_basket, :only => [:index, :create]
  cache_sweeper :circulation_sweeper, :only => [:create, :update, :destroy]

  # GET /checkins
  # GET /checkins.json
  def index
    # かごがない場合、自動的に作成する
    unless @basket
      @basket = Basket.create!(:user => current_user)
      redirect_to basket_checkins_url(@basket)
      return
    end
    @checkins = @basket.checkins.order('checkins.created_at DESC').all

    @checkin = @basket.checkins.new

    respond_to do |format|
      format.html # index.rhtml
      format.json { render :json => @checkins }
      format.js
    end
  end

  # GET /checkins/1
  # GET /checkins/1.json
  def show
    #@checkin = Checkin.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.json { render :json => @checkin }
    end
  end

  # GET /checkins/new
  def new
    #@checkin = @basket.checkins.new
    redirect_to checkins_url
  end

  # GET /checkins/1/edit
  def edit
    #@checkin = Checkin.find(params[:id])
  end

  # POST /checkins
  # POST /checkins.json
  def create
    unless @basket
      @basket = Basket.new(:user => current_user)
      @basket.save(:validate => false)
    end
    @checkin = @basket.checkins.new(params[:checkin])
    @checkin.librarian = current_user

    flash[:message] = ''
    if @checkin.item_identifier.blank?
      flash[:message] << t('checkin.enter_item_identifier') if @checkin.item_identifier.blank?
    else
      item = Item.where(:item_identifier => @checkin.item_identifier.to_s.strip).first
    end

    if item.blank?
      flash[:message] << t('checkin.item_not_found')
    else
      if @basket.checkins.collect(&:item).include?(item)
        flash[:message] << t('checkin.already_checked_in')
      end
    end

    respond_to do |format|
      unless item
        format.html { redirect_to basket_checkins_url(@checkin.basket) }
        format.json { render :json => @checkin.errors, :status => :unprocessable_entity }
        format.js {
          redirect_to basket_checkins_url(@checkin.basket, :mode => 'list', :format => :js)
        }
      else
        @checkin.item = item
        if @checkin.save(:validate => false)
        # 速度を上げるためvalidationを省略している
          #flash[:message] << t('controller.successfully_created', :model => t('activerecord.models.checkin'))
          flash[:message] << t('checkin.successfully_checked_in', :model => t('activerecord.models.checkin'))
          message = @checkin.item_checkin(current_user)
          flash[:message] << message if message
          format.html { redirect_to basket_checkins_url(@checkin.basket) }
          format.json { render :json => @checkin, :status => :created, :location => @checkin }
          format.js {
            redirect_to basket_checkins_url(@checkin.basket, :mode => 'list', :format => :js)
          }
        else
          format.html { render :action => "new" }
          format.json { render :json => @checkin.errors, :status => :unprocessable_entity }
          format.js {
            redirect_to basket_checkins_url(@basket, :mode => 'list', :format => :js)
          }
        end
      end
    end
  end

  # PUT /checkins/1
  # PUT /checkins/1.json
  def update
    #@checkin = Checkin.find(params[:id])
    @checkin.item_identifier = params[:checkin][:item_identifier] rescue nil
    unless @checkin.item_identifier.blank?
      item = Item.where(:item_identifier => @checkin.item_identifier.to_s.strip).first
    end
    @checkin.item = item

    respond_to do |format|
      if @checkin.update_attributes(params[:checkin])
        format.html { redirect_to @checkin, :notice => t('controller.successfully_updated', :model => t('activerecord.models.checkin')) }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @checkin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /checkins/1
  # DELETE /checkins/1.json
  def destroy
    #@checkin = Checkin.find(params[:id])
    @checkin.destroy

    respond_to do |format|
      format.html { redirect_to checkins_url }
      format.json { head :no_content }
    end
  end
end
