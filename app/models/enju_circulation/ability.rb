module EnjuCirculation
  class Ability
    include CanCan::Ability
    
    def initialize(user, ip_address = nil)
      case user.try(:role).try(:name)
      when 'Administrator'
        can :manage, [
          Demand,
        ]
      when 'Librarian'
        can :manage, [
          Demand,
        ]
      end
    end
  end
end
