class ApplicationController < ActionController::Base
  protect_from_forgery

  include EnjuLibrary::Controller
  include EnjuBiblio::Controller
  include EnjuCirculation::Controller
  after_action :verify_authorized, unless: :devise_controller?

  include Pundit
end
