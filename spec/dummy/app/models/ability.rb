class Ability
  include CanCan::Ability

  def initialize(user)
    case user.try(:role).try(:name)
    when 'Administrator'
      can :manage, [
        Basket,
        CarrierTypeHasCheckoutType,
        CheckedItem,
        Checkin,
        CheckoutStatHasManifestation,
        CheckoutStatHasUser,
        CheckoutType,
        ItemHasUseRestriction,
        ManifestationCheckoutStat,
        ManifestationReserveStat,
        Reserve,
        ReserveStatHasManifestation,
        ReserveStatHasUser,
        UserCheckoutStat,
        UserGroupHasCheckoutType,
        UserReserveStat
      ]
      can [:read, :create, :update, :remove_all], Checkout
      can :destroy, Checkout do |checkout|
        checkout.checkin
      end
      can [:read, :update], [
        CirculationStatus,
        LendingPolicy,
        UseRestriction
      ]
      can :destroy, LendingPolicy
      can [:read, :create, :update], Item
      can :destroy, Item do |item|
        item.deletable?
      end
      can [:read, :create, :update], Manifestation
      can :destroy, Manifestation do |manifestation|
        manifestation.items.empty? and !manifestation.periodical_master? and !manifestation.is_reserved?
      end
    when 'Librarian'
      can :manage, [
        Basket,
        CheckedItem,
        Checkin,
        ManifestationCheckoutStat,
        ManifestationReserveStat,
        Reserve
      ]
      can [:read, :create, :update, :remove_all], Checkout
      can :destroy, Checkout do |checkout|
        checkout.checkin
      end
      can [:read, :create, :update], UserCheckoutStat
      can [:read, :create, :update], UserReserveStat
      can :read, [
        CarrierTypeHasCheckoutType,
        CheckoutType,
        CheckoutStatHasManifestation,
        CheckoutStatHasUser,
        CirculationStatus,
        ItemHasUseRestriction,
        LendingPolicy,
        ReserveStatHasManifestation,
        ReserveStatHasUser,
        UseRestriction,
        UserGroupHasCheckoutType
      ]
      can [:read, :create, :update], Item
      can :destroy, Item do |item|
        item.checkouts.not_returned.empty?
      end
      can [:read, :create, :update], Manifestation
      can :destroy, Manifestation do |manifestation|
        manifestation.items.empty? and !manifestation.periodical_master? and !manifestation.is_reserved?
      end
    when 'User'
      can [:index, :create, :remove_all], Checkout
      can [:show, :update], Checkout do |checkout|
        checkout.user == user
      end
      can :destroy, Checkout do |checkout|
        checkout.user == user && checkout.checkin
      end
      can :index, Reserve
      can :create, Reserve do |reserve|
        user.user_number.present?
      end
      can [:show, :update, :destroy], Reserve do |reserve|
        reserve.user == user
      end
      can :read, [
        CirculationStatus,
        ManifestationCheckoutStat,
        ManifestationReserveStat,
        UserCheckoutStat,
        UserReserveStat,
      ]
      can :index, Item
      can :show, Item do |item|
        item.required_role_id <= 2
      end
      can :read, Manifestation do |manifestation|
        manifestation.required_role_id <= 2
      end
      can :edit, Manifestation
    else
      can :index, Checkout
      can :read, [
        CirculationStatus,
        ManifestationCheckoutStat,
        ManifestationReserveStat,
        UserCheckoutStat,
        UserReserveStat
      ]
      can :read, Item
      can :read, Manifestation
    end
  end
end
