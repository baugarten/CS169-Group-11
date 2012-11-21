OneProsper::Application.routes.draw do

  resources :projects

  devise_for :users
  devise_for :admins

  scope "/admin" do
    resources :users do 
      member do
        post "promote"
      end
    end
    resources :admins do
    end
  end

  root :to => "application#frontpage"
  
  match 'dashboard' => 'dashboard#show'
  match 'dashboard/edit' => 'dashboard#edit'
  match 'dashboard/update' => 'dashboard#update'
  match 'campaign/farmers' => 'campaigns#farmers'
  

  resources :projects do
    member do
      get 'donate'
      post 'charge'
    end
  end

  resource :campaign do
    member do
      get 'select_farmer'
      get 'friends'
      put 'submit_friends'
      get 'video'
      put 'submit_video'
      get 'template'
      put 'submit_template'
    end
  end

  resources :campaigns do
    member do
      get 'manager'
      get 'track'
      get 'confirm_watched'
    end
  end

  match 'photo/:id' => 'photo#display', :as => :photo
  match 'assets/before.jpeg' => 'photo#default', :as => 'default_photo'
  
  resources :updates
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
