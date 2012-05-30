require "enju_circulation/engine"
require "enju_circulation/manifestation"
require "enju_circulation/controller"

module EnjuCirculation
end

ActionController::Base.send :include, EnjuCirculation::Controller
ActiveRecord::Base.send :include, EnjuCirculation::Manifestation
