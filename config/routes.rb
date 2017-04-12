# == Route Map
#
#     Prefix Verb   URI Pattern                Controller#Action
#       root GET    /                          events#index
#     events GET    /events(.:format)          events#index
#            POST   /events(.:format)          events#create
#  new_event GET    /events/new(.:format)      events#new
# edit_event GET    /events/:id/edit(.:format) events#edit
#      event GET    /events/:id(.:format)      events#show
#            PATCH  /events/:id(.:format)      events#update
#            PUT    /events/:id(.:format)      events#update
#            DELETE /events/:id(.:format)      events#destroy
#      bills GET    /bills(.:format)           bills#index
#            POST   /bills(.:format)           bills#create
#   new_bill GET    /bills/new(.:format)       bills#new
#  edit_bill GET    /bills/:id/edit(.:format)  bills#edit
#       bill GET    /bills/:id(.:format)       bills#show
#            PATCH  /bills/:id(.:format)       bills#update
#            PUT    /bills/:id(.:format)       bills#update
#            DELETE /bills/:id(.:format)       bills#destroy
#      users GET    /users(.:format)           users#index
#            POST   /users(.:format)           users#create
#   new_user GET    /users/new(.:format)       users#new
#  edit_user GET    /users/:id/edit(.:format)  users#edit
#       user GET    /users/:id(.:format)       users#show
#            PATCH  /users/:id(.:format)       users#update
#            PUT    /users/:id(.:format)       users#update
#            DELETE /users/:id(.:format)       users#destroy
#

Billapp::Application.routes.draw do


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'events#index'

  resources :events
  resources :bills
  resources :users

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
