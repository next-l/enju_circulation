require "enju_circulation/engine"
require "enju_circulation/manifestation"
require "enju_circulation/item"
require "enju_circulation/user"
require "enju_circulation/user_group"
require "enju_circulation/profile"
require "enju_circulation/accept"
require "enju_circulation/basket"
require "enju_circulation/carrier_type"
require "enju_circulation/withdraw"
require "enju_circulation/controller"
require "enju_circulation/helper"

module EnjuCirculation
end

ActionController::Base.send :include, EnjuCirculation::Controller
ActiveRecord::Base.send :include, EnjuCirculation::EnjuManifestation
ActiveRecord::Base.send :include, EnjuCirculation::EnjuItem
ActiveRecord::Base.send :include, EnjuCirculation::EnjuUser
ActiveRecord::Base.send :include, EnjuCirculation::EnjuUserGroup
ActiveRecord::Base.send :include, EnjuCirculation::EnjuProfile
ActiveRecord::Base.send :include, EnjuCirculation::EnjuAccept
ActiveRecord::Base.send :include, EnjuCirculation::EnjuBasket
ActiveRecord::Base.send :include, EnjuCirculation::EnjuCarrierType
ActiveRecord::Base.send :include, EnjuCirculation::EnjuWithdraw
ActionView::Base.send :include, EnjuCirculation::ManifestationsHelper
