class CheckoutPolicy < AdminPolicy
  def index?
    user.try(:has_role?, 'User')
  end

  def show?
    if user.try(:has_role?, 'Librarian')
      true
    elsif user and user == record.user
      true
    end
  end

  def create?
    user.try(:has_role?, 'Librarian')
  end

  def update?
    if user.try(:has_role?, 'Librarian')
      true
    elsif user and user == record.user
      true
    end
  end

  def destroy?
    if record.checkin
      if user.try(:has_role?, 'Librarian')
        true
      elsif user and user == record.user
        true
      end
    end
  end
end
