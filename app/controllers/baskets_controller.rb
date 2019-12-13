require_dependency EnjuLibrary::Engine.config.root.join('app', 'controllers', 'baskets_controller.rb').to_s

class BasketsController < ApplicationController
  include EnjuCirculation::BasketsController
end
