class ItemPolicy < AdminPolicy
  def index?
    true
  end

  def create?
    user.try(:has_role?, 'Librarian')
  end

  def update?
    user.try(:has_role?, 'Librarian')
  end

  def destroy?
    if user.try(:has_role?, 'Librarian')
      return false if record.rent?
      return false if record.reserved?
      true
    end
  end
end
