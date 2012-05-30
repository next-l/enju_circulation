require "enju_circulation/engine"
require "enju_circulation/manifestation"

module EnjuCirculation
end

ActiveRecord::Base.send :include, EnjuCirculation::Manifestation
