module EnjuCirculation
  module BasketsController
    extend ActiveSupport::Concern

    included do
      # POST /baskets
      # POST /baskets.json
      def create
        @basket = Basket.new(basket_params)
        @user = Profile.find_by(user_number: @basket.user_number)&.user if @basket.user_number.present?
        if @user
          @basket.user = @user
        end

        respond_to do |format|
          if @basket.save
            format.html {
              redirect_to new_checked_item_url(basket_id: @basket.id), notice: t('controller.successfully_created', model: t('activerecord.models.basket'))
            }
            format.json { render json: @basket, status: :created, location:  @basket }
          else
            format.html { render action: "new" }
            format.json { render json: @basket.errors, status: :unprocessable_entity }
          end
        end
      end

      # PUT /baskets/1
      # PUT /baskets/1.json
      def update
        librarian = current_user
        begin
          unless @basket.basket_checkout(librarian)
            redirect_to new_checked_item_url(basket_id: @basket.id)
            return
          end
        rescue ActiveRecord::RecordInvalid
          flash[:message] = t('checked_item.already_checked_out_try_again')
          @basket.checked_items.delete_all
          redirect_to new_checked_item_url(basket_id: @basket.id)
          return
        end

        respond_to do |format|
          # if @basket.update_attributes({})
          if @basket.save(validate: false)
            # 貸出完了時
            format.html {
              redirect_to checkouts_url(user_id: @basket.user.username), notice: t('basket.checkout_completed')
            }
            format.json { head :no_content }
          else
            format.html {
              redirect_to checked_items_url(basket_id: @basket.id)
            }
            format.json { render json: @basket.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /baskets/1
      # DELETE /baskets/1.json
      def destroy
        @basket.destroy

        respond_to do |format|
          format.html {
            redirect_to checkouts_url(user_id: @basket.user.username)
          }
          format.json { head :no_content }
        end
      end
    end
  end
end
