class CheckedItemPolicy < AdminPolicy
  def new?
    user.try(:has_role?, 'Librarian')
  end

  def create?
    if user.try(:has_role?, 'Librarian')
      true if record.basket
    end
  end

  def update?
    user.try(:has_role?, 'Librarian')
  end

  def destroy?
    user.try(:has_role?, 'Librarian')
  end
end
