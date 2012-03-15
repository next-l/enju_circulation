class CheckoutsController < ApplicationController
  before_filter :store_location, :only => :index
  load_and_authorize_resource :except => :index
  authorize_resource :only => :index
  before_filter :get_user_if_nil, :only => :index
  helper_method :get_item
  after_filter :convert_charset, :only => :index
  cache_sweeper :circulation_sweeper, :only => [:create, :update, :destroy]

  # GET /checkouts
  # GET /checkouts.json

  def index
    if params[:icalendar_token].present?
      icalendar_user = User.where(:checkout_icalendar_token => params[:icalendar_token]).first
      if icalendar_user.blank?
        raise ActiveRecord::RecordNotFound
      else
        checkouts = icalendar_user.checkouts.not_returned.order('checkouts.id DESC')
      end
    else
      unless current_user
        access_denied; return
      end
    end

    unless icalendar_user
      if current_user.try(:has_role?, 'Librarian')
        if @user
          checkouts = @user.checkouts.not_returned.order('checkouts.id DESC').page(params[:page])
        else
          if params[:view] == 'overdue'
            if params[:days_overdue]
              date = params[:days_overdue].to_i.days.ago.beginning_of_day
            else
              date = 1.days.ago.beginning_of_day
            end
            checkouts = Checkout.overdue(date).order('checkouts.id DESC').page(params[:page])
          else
            checkouts = Checkout.not_returned.order('checkouts.id DESC').page(params[:page])
          end
        end
      else
        # 一般ユーザ
        if current_user == @user
          redirect_to checkouts_url(:format => params[:format])
          return
        else
          if @user
            access_denied
            return
          else
            checkouts = current_user.checkouts.not_returned.order('checkouts.id DESC').page(params[:page])
          end
        end
      end
    end

    @days_overdue = params[:days_overdue] ||= 1
    if params[:format] == 'csv'
      @checkouts = checkouts
    else
      @checkouts = checkouts.page(params[:page])
    end

    respond_to do |format|
      format.html # index.rhtml
      format.json { render :json => @checkouts.to_json }
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
      format.html # show.rhtml
      format.json { render :json => @checkout.to_json }
    end
  end

  # GET /checkouts/1;edit
  def edit
    @new_due_date = @checkout.get_new_due_date
  end

  # PUT /checkouts/1
  # PUT /checkouts/1.json
  def update
    if @checkout.reserved?
      flash[:notice] = t('checkout.this_item_is_reserved')
      redirect_to edit_checkout_url(@checkout)
      return
    end
    if @checkout.over_checkout_renewal_limit?
      flash[:notice] = t('checkout.excessed_renewal_limit')
      redirect_to edit_checkout_url(@checkout)
      return
    end
    if @checkout.overdue?
      flash[:notice] = t('checkout.you_have_overdue_item')
      unless current_user.has_role?('Librarian')
        redirect_to edit_checkout_url(@checkout)
        return
      end
    end
    @checkout.reload
    @checkout.checkout_renewal_count += 1

    respond_to do |format|
      if @checkout.update_attributes(params[:checkout])
        flash[:notice] = t('controller.successfully_updated', :model => t('activerecord.models.checkout'))
        format.html { redirect_to(@checkout) }
        format.json { head :ok }
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
    @checkout.user_id = nil
    @checkout.save!

    respond_to do |format|
      flash[:notice] = t('controller.successfully_deleted', :model => t('activerecord.models.checkout'))
      format.html { redirect_to user_checkouts_url(user) }
      format.json { head :ok }
    end
  end
end
