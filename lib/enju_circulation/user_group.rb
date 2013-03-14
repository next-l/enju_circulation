module EnjuCirculation
  module EnjuUserGroup
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def enju_circulation_user_group_model
        has_many :user_group_has_checkout_types, :dependent => :destroy
        has_many :checkout_types, :through => :user_group_has_checkout_types, :order => :position
        has_many :lending_policies

        validates_numericality_of :number_of_day_to_notify_due_date,
          :number_of_day_to_notify_overdue,
          :number_of_time_to_notify_overdue,
          :greater_than_or_equal_to => 0
      end
    end
  end
end
