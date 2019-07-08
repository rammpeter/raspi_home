Rails.application.routes.draw do
  get  'konfiguration/show_konfiguration'
  post 'konfiguration/show_konfiguration'

  get  'auswertung/list_temperatur_verlauf'
  post 'auswertung/list_temperatur_verlauf'

  get  'auswertung/show_statistik'
  post 'auswertung/show_statistik'

  get  'auswertung/show_temperatur_verlauf'
  post 'auswertung/show_temperatur_verlauf'

  get  'auswertung/show_temperatur_verlauf_aktuell'
  post 'auswertung/show_temperatur_verlauf_aktuell'

  get  'konfiguration/save_konfiguration'
  post 'konfiguration/save_konfiguration'

  get  'konfiguration/show_globale_historie'
  post 'konfiguration/show_globale_historie'

  get  'konfiguration/show_historie'
  post 'konfiguration/show_historie'

  get  'konfiguration/show_konfiguration'
  post 'konfiguration/show_konfiguration'

  get  'welcome/index'
  post 'welcome/index'

  get  'welcome/authenticate'
  post 'welcome/authenticate'

  get  'welcome/do_auth'
  post 'welcome/do_auth'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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
