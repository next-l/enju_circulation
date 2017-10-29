class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include EnjuBiblio::Controller
  include EnjuLibrary::Controller
  include EnjuCirculation::Controller
  after_action :verify_authorized

  include Pundit
end
