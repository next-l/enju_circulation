require_dependency EnjuLibrary::Engine.config.root.join('app', 'controllers', 'baskets_controller.rb').to_s

class BasketsController
  include EnjuCirculation::BasketsController
end
