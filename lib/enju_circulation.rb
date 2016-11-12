require 'enju_circulation/engine'
require 'enju_circulation/helper'

module EnjuCirculation
end

ActionView::Base.send :include, EnjuCirculation::ManifestationsHelper
