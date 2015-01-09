module EnjuCirculation
  class Ability
    include CanCan::Ability
    
    def initialize(user, ip_address = nil)
      case user.try(:role).try(:name)
      when 'Administrator'
        can [:destroy, :delete], Manifestation do |manifestation|
          manifestation.items.empty? and !manifestation.series_master? and !manifestation.is_reserved?
        end
        can [:destroy, :delete], Item do |item|
          true if item.removable?
        end
        can :manage, [
          Basket,
          CarrierTypeHasCheckoutType,
          CheckedItem,
          Checkin,
          CheckoutStatHasManifestation,
          CheckoutStatHasUser,
          CheckoutType,
	  Demand,
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
        can [:destroy, :delete], Checkout do |checkout|
          checkout.checkin
        end
        can [:read, :update], [
          CirculationStatus,
          LendingPolicy,
          UseRestriction
        ]
        can [:destroy, :delete], LendingPolicy
      when 'Librarian'
        can [:destroy, :delete], Item do |item|
          true if item.removable?
        end
        can [:destroy, :delete], Manifestation do |manifestation|
          manifestation.items.empty? and !manifestation.series_master? and !manifestation.is_reserved?
        end
        can :manage, [
          Basket,
          CheckedItem,
          Checkin,
	  Demand,
          ManifestationCheckoutStat,
          ManifestationReserveStat,
          Reserve
        ]
        can [:read, :create, :update, :remove_all], Checkout
        can [:destroy, :delete], Checkout do |checkout|
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
      when 'User'
        can [:index, :create, :remove_all], Checkout
        can [:show, :update], Checkout do |checkout|
          checkout.user == user
        end
        can [:destroy, :delete], Checkout do |checkout|
          checkout.user == user && checkout.checkin
        end
        can :index, Reserve
        can :create, Reserve do |reserve|
          user.profile.user_number.try(:present?)
        end
        can [:show, :update, :destroy, :delete], Reserve do |reserve|
          reserve.user == user
        end
        can :read, [
          CirculationStatus,
          ManifestationCheckoutStat,
          ManifestationReserveStat,
          UserCheckoutStat,
          UserReserveStat,
        ]
      else
        can :index, Checkout
        can :read, [
          CirculationStatus,
          ManifestationCheckoutStat,
          ManifestationReserveStat,
          UserCheckoutStat,
          UserReserveStat
        ]
      end
    end
  end
end
