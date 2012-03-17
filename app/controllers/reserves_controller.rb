# -*- encoding: utf-8 -*-
class ReservesController < ApplicationController
  before_filter :store_location, :only => :index
  load_and_authorize_resource :except => :index
  authorize_resource :only => :index
  before_filter :get_user_if_nil, :only => [:index, :new]
  before_filter :store_page
  helper_method :get_manifestation
  helper_method :get_item

  # GET /reserves
  # GET /reserves.json
  def index
    unless current_user.has_role?('Librarian')
      if @user
        if current_user == @user
          redirect_to reserves_url(:format => params[:format])
          return
        else
          access_denied; return
        end
      end
    end

    if params[:mode] == 'hold' and current_user.has_role?('Librarian')
      @reserves = Reserve.hold.order('reserves.id DESC').page(params[:page])
    else
      if @user
        if current_user.has_role?('Librarian')
          @reserves = @user.reserves.order('reserves.id DESC').page(params[:page])
        else
          access_denied; return
        end
      else
        if current_user.has_role?('Librarian')
          @reserves = Reserve.order('reserves.id DESC').includes(:manifestation).page(params[:page])
        else
          @reserves = current_user.reserves.order('reserves.id DESC').includes(:manifestation).page(params[:page])
        end
      end
    end

    respond_to do |format|
      format.html # index.rhtml
      format.json { render :json => @reserves }
      format.rss  { render :layout => false }
      format.atom
      format.csv
    end
  end

  # GET /reserves/1
  # GET /reserves/1.json
  def show
    respond_to do |format|
      format.html # show.rhtml
      format.json { render :json => @reserve }
    end
  end

  # GET /reserves/new
  def new
    if params[:reserve]
      user = User.where(:user_number => params[:reserve][:user_number]).first
    else
      user = @user if @user
    end

    unless current_user.has_role?('Librarian')
      if user
        if user != current_user
          access_denied; return
        end
      end
    end

    if user
      @reserve = user.reserves.new
    else
      @reserve = current_user.reserves.new
    end

    get_manifestation
    if @manifestation
      @reserve.manifestation = @manifestation
      if user
        @reserve.expired_at = @manifestation.reservation_expired_period(user).days.from_now.end_of_day
        if @manifestation.is_reserved_by?(user)
          flash[:notice] = t('reserve.this_manifestation_is_already_reserved')
          redirect_to @manifestation
          return
        end
      end
    end
  end

  # GET /reserves/1/edit
  def edit
  end

  # POST /reserves
  # POST /reserves.json
  def create
    begin
      if params[:reserve][:user_number]
        user = User.where(:user_number => params[:reserve][:user_number]).first
      end
    rescue NoMethodError
    end

    # 図書館員以外は自分の予約しか作成できない
    unless current_user.has_role?('Librarian')
      if user != current_user
        access_denied
        return
      end
    end

    if user
      @reserve = user.reserves.new(params[:reserve])
    else
      @reserve = current_user.reserves.new(params[:reserve])
    end

    respond_to do |format|
      if @reserve.save
        @reserve.send_message('accepted')

        #format.html { redirect_to reserve_url(@reserve) }
        format.html { redirect_to @reserve, :notice => t('controller.successfully_created', :model => t('activerecord.models.reserve')) }
        format.json { render :json => @reserve, :status => :created, :location => reserve_url(@reserve) }
      else
        format.html { render :action => "new" }
        format.json { render :json => @reserve.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reserves/1
  # PUT /reserves/1.json
  def update
    begin
      if params[:reserve][:user_number]
        user = User.where(:user_number => params[:reserve][:user_number]).first
      end
    rescue NoMethodError
    end

    unless current_user.has_role?('Librarian')
      if user
        if user != @reserve.user
          access_denied
          return
        end
      end
    end

    if params[:mode] == 'cancel'
      @reserve.sm_cancel!
    end

    respond_to do |format|
      if @reserve.update_attributes(params[:reserve])
        if @reserve.state == 'canceled'
          flash[:notice] = t('reserve.reservation_was_canceled')
          @reserve.send_message('canceled')
        else
          flash[:notice] = t('controller.successfully_updated', :model => t('activerecord.models.reserve'))
        end
        format.html { redirect_to @reserve }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @reserve.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reserves/1
  # DELETE /reserves/1.json
  def destroy
    @reserve.destroy
    #flash[:notice] = t('reserve.reservation_was_canceled')

    if @reserve.manifestation.is_reserved?
      if @reserve.item
        retain = @reserve.item.retain(User.find(1)) # TODO: システムからの送信ユーザの設定
        if retain.nil?
          flash[:message] = t('reserve.this_item_is_not_reserved')
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to reserves_url, :notice => t('controller.successfully_deleted', :model => t('activerecord.models.reserve')) }
      format.json { head :no_content }
    end
  end
end
