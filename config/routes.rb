Rails.application.routes.draw do
  resources :demands

  resources :use_restrictions
  resources :item_has_use_restrictions
  resources :lending_policies
  resources :circulation_statuses
  resources :baskets
  resources :user_checkout_stats
  resources :user_reserve_stats
  resources :manifestation_checkout_stats
  resources :manifestation_reserve_stats
  resources :carrier_type_has_checkout_types
  resources :user_group_has_checkout_types
  resources :checkout_types do
    resources :user_group_has_checkout_types
  end
  resources :user_groups do
    resources :user_group_has_checkout_types
  end
  resources :checkins
  resources :checked_items
  resources :checkouts do
    member do
      post 'notify_due_date'
      post 'notify_overdue'
    end
    put :remove_all, on: :collection
  end
  resources :reserves
  resources :items do
    resources :checked_items
    resources :checkouts
    resources :item_has_use_restrictions
  end
end
