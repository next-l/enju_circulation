class CheckoutPolicy < AdminPolicy
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
