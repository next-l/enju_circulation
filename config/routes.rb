Rails.application.routes.draw do
  resources :use_restrictions
  resources :item_has_use_restrictions
  resources :lending_policies
  resources :circulation_statuses
  resources :users do
    resources :baskets do
      resources :checked_items
      resources :checkins
    end
    resources :checkouts
    resources :reserves
  end
  resources :user_checkout_stats
  resources :user_reserve_stats
  resources :manifestation_checkout_stats
  resources :manifestation_reserve_stats
  resources :carrier_type_has_checkout_types
  resources :user_group_has_checkout_types
  resources :checkout_types do
    resources :user_group_has_checkout_types
  end
  resources :baskets do
    resources :checked_items
  end
  resources :user_groups do
    resources :user_group_has_checkout_types
  end
  resources :checkins
  resources :checked_items
  resources :checkouts
  resources :reserves
  resources :items do
    resources :checked_items
    resources :item_has_use_restrictions
    resources :lending_policies
  end
  resources :checkout_stat_has_manifestations
  resources :checkout_stat_has_users
  resources :reserve_stat_has_manifestations
  resources :reserve_stat_has_users
end
