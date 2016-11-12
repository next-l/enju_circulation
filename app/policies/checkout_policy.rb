class CheckoutPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    if user.try(:has_role?, 'Librarian')
      true
    elsif user && (user == record.user)
      true
    end
  end

  def create?
    user.try(:has_role?, 'Librarian')
  end

  def update?
    return true if user.try(:has_role?, 'Librarian')
    return true if user && (user == record.user)
    false
  end

  def destroy?
    if record.checkin
      return true if user.try(:has_role?, 'Librarian')
      return true if user && (user == record.user)
    end
    false
  end

  def remove_all?
    true if user.try(:has_role?, 'User')
  end
end
