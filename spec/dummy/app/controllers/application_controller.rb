class ApplicationController < ActionController::Base
  protect_from_forgery

  include EnjuLibrary::Controller
  include EnjuBiblio::Controller
  include EnjuCirculation::Controller
  before_action :set_paper_trail_whodunnit
  after_action :verify_authorized

  include Pundit
end
