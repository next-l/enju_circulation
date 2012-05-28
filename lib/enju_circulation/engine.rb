require "devise"
require "cancan"
require "validates_timeliness"
require "attribute_normalizer"
require "inherited_resources"
require "state_machine"
require "friendly_id"
require "will_paginate"
require "sunspot_rails"
require "enju_message"
require "enju_event"
require "acts_as_list"

module EnjuCirculation
  class Engine < ::Rails::Engine
  end
end
