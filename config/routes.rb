Rails.application.routes.draw do
  get "/users/:user_id/checkouts" => redirect("/checkouts?user_id=%{user_id}")
  get "/users/:user_id/reserves" => redirect("/reserves?user_id=%{user_id}")
  get "/users/:user_id/baskets" => redirect("/baskets?user_id=%{user_id}")
  get "/baskets/:basket_id/checked_items" => redirect("/checked_items?basket_id=%{basket_id}")
  get "/baskets/:basket_id/checkins" => redirect("/checkins?basket_id=%{basket_id}")

  resources :use_restrictions
  resources :item_has_use_restrictions
  resources :lending_policies
  resources :circulation_statuses
  resources :baskets do
    resources :checked_items
    resources :checkins
  end
  resources :users do
    resources :checkouts, :only => :index do
      put :remove_all, :on => :collection
    end
    resources :reserves, :only => :index
    resources :baskets, :only => :index
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
    resources :checkouts
  end
  resources :checkout_stat_has_manifestations
  resources :checkout_stat_has_users
  resources :reserve_stat_has_manifestations
  resources :reserve_stat_has_users
end
