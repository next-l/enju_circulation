require "enju_circulation/engine"
require "enju_circulation/manifestation"
require "enju_circulation/item"
require "enju_circulation/user"
require "enju_circulation/controller"
require "enju_circulation/helper"

module EnjuCirculation
end

ActionController::Base.send :include, EnjuCirculation::Controller
ActiveRecord::Base.send :include, EnjuCirculation::EnjuManifestation
ActiveRecord::Base.send :include, EnjuCirculation::EnjuItem
ActiveRecord::Base.send :include, EnjuCirculation::EnjuUser
ActionView::Base.send :include, EnjuCirculation::ManifestationsHelper
