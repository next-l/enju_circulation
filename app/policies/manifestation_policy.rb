class ManifestationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    case user.try(:role).try(:name)
    when 'Administrator'
      true
    when 'Librarian'
      true if record.required_role_id <= 3
    when 'User'
      true if record.required_role_id <= 2
    else
      true if record.required_role_id <= 1
    end
  end

  def create?
    true if user.try(:has_role?, 'Librarian')
  end

  def edit?
    case user.try(:role).try(:name)
    when 'Administrator'
      true
    when 'Librarian'
      true if record.required_role_id <= 3
    when 'User'
      true if record.required_role_id <= 2
    end
  end

  def update?
    true if user.try(:has_role?, 'Librarian')
  end

  def destroy?
    if record.items.empty?
      if !record.try(:is_reserved?)
        if record.series_master?
          if record.children.empty?
            case user.try(:role).try(:name)
            when 'Administrator'
              true
            when 'Librarian'
              true if record.required_role_id <= 3
            else
              false
            end
          else
            false
          end
        else
          case user.try(:role).try(:name)
          when 'Administrator'
            true
          when 'Librarian'
            true if record.required_role_id <= 3
          else
            false
          end
        end
      end
    end
  end
end
