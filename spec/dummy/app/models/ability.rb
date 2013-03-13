#module EnjuCirculation
  class Ability
    include CanCan::Ability
    
    def initialize(user, ip_address = nil)
      case user.try(:role).try(:name)
      when 'Administrator'
        can [:delete, :destroy], Manifestation do |manifestation|
          manifestation.items.empty? and !manifestation.periodical_master? and !manifestation.is_reserved?
        end
        can [:delete, :destroy], User do |u|
          u.deletable? and u != user
        end
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
        can [:delete, :destroy], Checkout do |checkout|
          checkout.checkin
        end
        can [:read, :update], [
          CirculationStatus,
          LendingPolicy,
          UseRestriction
        ]
        can [:delete, :destroy], LendingPolicy
        can :read, [Item, Manifestation]
      when 'Librarian'
        can [:delete, :destroy], Item do |item|
          item.checkouts.not_returned.empty?
        end
        can [:delete, :destroy], Manifestation do |manifestation|
          manifestation.items.empty? and !manifestation.periodical_master? and !manifestation.is_reserved?
        end
        can [:delete, :destroy], User do |u|
          u.deletable? and u.role.name == 'User' and u != user
        end
        can :manage, [
          Basket,
          CheckedItem,
          Checkin,
          ManifestationCheckoutStat,
          ManifestationReserveStat,
          Reserve
        ]
        can [:read, :create, :update, :remove_all], Checkout
        can [:delete, :destroy], Checkout do |checkout|
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
        can :read, [Item, Manifestation]
      when 'User'
        can [:index, :create, :remove_all], Checkout
        can [:show, :update], Checkout do |checkout|
          checkout.user == user
        end
        can [:delete, :destroy], Checkout do |checkout|
          checkout.user == user && checkout.checkin
        end
        can :index, Reserve
        can :create, Reserve do |reserve|
          user.user_number.present?
        end
        can [:show, :update, :delete, :destroy], Reserve do |reserve|
          reserve.user == user
        end
        can :read, [
          CirculationStatus,
          ManifestationCheckoutStat,
          ManifestationReserveStat,
          UserCheckoutStat,
          UserReserveStat,
        ]
        can :read, [Item, Manifestation]
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
#end
