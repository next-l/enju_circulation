# http://blog.carbonfive.com/2013/10/21/migrating-to-pundit-from-cancan/
module PunditViewPolicy
  extend ActiveSupport::Concern

  included do
    before do
      controller.singleton_class.class_eval do
        def policy(_instance)
          Class.new do
            def method_missing(*_args)
              true
            end
          end.new
        end
        helper_method :policy
      end
    end
  end
end

RSpec.configure do |config|
  config.include PunditViewPolicy, type: :view
end
