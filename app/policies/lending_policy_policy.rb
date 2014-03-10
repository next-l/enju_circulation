class LendingPolicyPolicy < AdminPolicy
  def destroy?
    user.try(:has_role?, 'Administrator')
  end
end
