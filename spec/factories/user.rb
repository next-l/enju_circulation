FactoryGirl.define do
  factory :admin, :class => User do |f|
    f.sequence(:username){|n| "admin_#{n}"}
    f.sequence(:email){|n| "admin_#{n}@example.jp"}
    f.email_confirmation{|u| u.email}
    f.role {Role.find_by_name('Administrator')}
    f.password 'adminpassword'
    f.password_confirmation 'adminpassword'
    f.user_group {UserGroup.first}
    f.required_role {Role.find_by_name('User')}
    f.sequence(:user_number){|n| "user_number_admin_#{n}"}
    f.library {Library.find(2)}
    f.locale "ja"
  end

  factory :librarian, :class => User do |f|
    f.sequence(:username){|n| "librarian_#{n}"}
    f.sequence(:email){|n| "librarian_#{n}@example.jp"}
    f.email_confirmation{|u| u.email}
    f.role {Role.find_by_name('Librarian')}
    f.password 'librarianpassword'
    f.password_confirmation 'librarianpassword'
    f.user_group {UserGroup.first}
    f.required_role {Role.find_by_name('User')}
    f.sequence(:user_number){|n| "user_number_librarian_#{n}"}
    f.library {Library.find(2)}
    f.locale "ja"
  end

  factory :user, :class => User do |f|
    f.sequence(:username){|n| "user_#{n}"}
    f.sequence(:email){|n| "user_#{n}@example.jp"}
    f.email_confirmation{|u| u.email}
    f.role {Role.find_by_name('User')}
    f.password 'userpassword'
    f.password_confirmation 'userpassword'
    f.user_group {UserGroup.find(2)}
    f.required_role {Role.find_by_name('User')}
    f.sequence(:user_number){|n| "user_number_user_#{n}"}
    f.library {Library.find(2)}
    f.locale "ja"
  end

  factory :invalid_user, :class => User do |f|
  end
end
