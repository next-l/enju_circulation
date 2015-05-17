class User < ActiveRecord::Base
  enju_leaf_user_model
  enju_circulation_user_model
  enju_message_user_model
end
