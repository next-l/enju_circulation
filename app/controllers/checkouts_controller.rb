class CheckoutsController < ApplicationController
  before_action :set_checkout, only: [:show, :edit, :update, :destroy]
  before_action :store_location, :only => :index
  before_action :get_user, :only => [:index, :remove_all]
  before_action :get_item, :only => :index
  after_action :convert_charset, :only => :index
  after_action :verify_authorized

  # GET /checkouts
  # GET /checkouts.json
  def index
    if params[:icalendar_token].present?
      icalendar_user = User.where(:checkout_icalendar_token => params[:icalendar_token]).first
      if icalendar_user.blank?
        raise ActiveRecord::RecordNotFound
      else
        @checkouts = icalendar_user.checkouts.not_returned.order('checkouts.id DESC')
      end
    else
      unless current_user
        access_denied; return
      end
    end

    if params[:format] == 'csv'
      per_page = 65534
    else
      per_page = Checkout.default_per_page
    end

    unless icalendar_user
      search = Checkout.search
      if @user
        user = @user
        if current_user.try(:has_role?, 'Librarian')
          search.build do
            with(:username).equal_to user.username
            with(:checked_in_at).equal_to nil unless user.save_checkout_history
          end
        else
          if current_user == user
            redirect_to checkouts_url(:format => params[:format])
            return
          else
            access_denied
            return
          end
        end
      else
        unless current_user.try(:has_role?, 'Librarian')
          search.build do
            with(:username).equal_to current_user.username
          end
        end

        search.build do
          with(:checked_in_at).equal_to nil
        end
      end

      if current_user.try(:has_role?, 'Librarian')
        if @item
          item = @item
          search.build do
            with(:item_identifier).equal_to item.item_identifier
          end
        end
      else
        if @item
          access_denied; return
        end
      end

      if params[:view] == 'overdue'
        if params[:days_overdue]
          date = params[:days_overdue].to_i.days.ago.beginning_of_day
        else
          date = 1.days.ago.beginning_of_day
        end
        search.build do
          with(:due_date).less_than date
          with(:checked_in_at).equal_to nil
        end
      end

      if params[:reserved].present?
        if params[:reserved] == 'true'
          @reserved = reserved = true
        elsif params[:reserved] == 'false'
          @reserved = reserved = false
        end
        search.build do
          with(:reserved).equal_to reserved
        end
      end

      search.build do
        order_by :created_at, :desc
        facet :reserved
      end
      page = params[:page] || 1
      search.query.paginate(page.to_i, Checkout.default_per_page)
      @checkouts = search.execute!.results
      @checkouts_facet = search.facet(:reserved).rows
    end

    @days_overdue = params[:days_overdue] ||= 1

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @checkouts }
      format.rss  { render :layout => false }
      format.ics
      format.csv
      format.atom
    end
  end

  # GET /checkouts/1
  # GET /checkouts/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @checkout }
    end
  end

  # GET /checkouts/1/edit
  def edit
    @new_due_date = @checkout.get_new_due_date
  end

  # PUT /checkouts/1
  # PUT /checkouts/1.json
  def update
    @checkout.assign_attributes(checkout_params)
    @checkout.due_date = @checkout.due_date.end_of_day
    @checkout.checkout_renewal_count += 1

    respond_to do |format|
      if @checkout.save
        format.html { redirect_to @checkout, :notice => t('controller.successfully_updated', :model => t('activerecord.models.checkout')) }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @checkout.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /checkouts/1
  # DELETE /checkouts/1.json
  def destroy
    user = @checkout.user
    @checkout.operator = current_user
    @checkout.user_id = nil
    @checkout.save!

    respond_to do |format|
      format.html { redirect_to user_checkouts_url(user), :notice => t('controller.successfully_deleted', :model => t('activerecord.models.checkout')) }
      format.json { head :no_content }
    end
  end

  def remove_all
    if @user
      unless current_user.has_role?('Librarian')
        if @user != current_user
          access_denied; return
        end
      end
      Checkout.remove_all_history(@user)
    end

    respond_to do |format|
      format.html { redirect_to checkouts_url, :notice => t('controller.successfully_deleted', :model => t('activerecord.models.checkout')) }
      format.json { head :no_content }
    end
  end

  private
  def set_checkout
    @checkout = Checkout.find(params[:id])
    authorize @checkout
  end

  def checkout_params
    params.require(:checkout).permit(:due_date)
  end
end
