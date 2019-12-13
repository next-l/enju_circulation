require_dependency EnjuBiblio::Engine.config.root.join('app', 'controllers', 'carrier_types_controller.rb').to_s

class CarrierTypesController
  include EnjuCirculation::CarrierTypesController
end
