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
          CheckoutStatHasManifestation,
          CheckoutStatHasUser,
          Demand,
          ItemHasUseRestriction,
          ReserveStatHasManifestation,
          ReserveStatHasUser,
          UserGroupHasCheckoutType,
        ]
        can [:read, :update], [
          LendingPolicy,
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
          Demand,
        ]
        can :read, [
          CarrierTypeHasCheckoutType,
          CheckoutStatHasManifestation,
          CheckoutStatHasUser,
          ItemHasUseRestriction,
          LendingPolicy,
          ReserveStatHasManifestation,
          ReserveStatHasUser,
          UserGroupHasCheckoutType
        ]
      end
    end
  end
end
