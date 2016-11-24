class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include EnjuBiblio::Controller
  include EnjuLibrary::Controller
  include EnjuCirculation::Controller
  before_action :set_paper_trail_whodunnit
  after_action :verify_authorized

  include Pundit
end
