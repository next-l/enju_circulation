require "enju_biblio"
require "enju_library"
require "enju_message"
require "enju_event"
require "protected_attributes" if Rails::VERSION::MAJOR == 4

module EnjuCirculation
  class Engine < ::Rails::Engine
  end
end
