require_dependency EnjuLibrary::Engine.config.root.join('app', 'controllers', 'user_groups_controller.rb').to_s

class UserGroupsController < ApplicationController
  include EnjuCirculation::UserGroupsController
end
