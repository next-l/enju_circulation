require_dependency EnjuBiblio::Engine.config.root.join('app', 'controllers', 'items_controller.rb').to_s

class ItemsController < ApplicationController
  include EnjuCirculation::ItemsController
end
