class CheckoutTypePolicy < AdminPolicy
  def create?
    user.try(:has_role?, 'Administrator')
  end

  def destroy?
    if user.try(:has_role?, 'Administrator')
      true if record.items.exists?
    end
  end
end
