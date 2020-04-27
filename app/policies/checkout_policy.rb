class CheckoutPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    if user&.has_role?('Librarian')
      true
    elsif user && (user == record.user)
      true
    end
  end

  def create?
    user&.has_role?('Librarian')
  end

  def update?
    if user&.has_role?('Librarian')
      true
    elsif user && (user == record.user)
      true
    end
  end

  def destroy?
    if record.checkin && record.user
      if user&.has_role?('Librarian')
        true
      elsif user && (user == record.user)
        true
      end
    end
  end

  def remove_all?
    true if user&.has_role?('User')
  end

  def notify_due_date?
    user&.has_role?('Librarian')
  end

  def notify_overdue?
    user&.has_role?('Librarian')
  end
end
