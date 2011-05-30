MongoSrc::Application.routes.draw do

  match 'space/:s/wish/new' =>'wishes#new'
  
  get 'follow/fo/:id', :action=>'fo',:controller=>'follow'
  get 'follow/unfo/:id', :action=>'unfo',:controller=>'follow'
  get 'follow/fo_tag/:tag', :action=>'fo_tag', :controller=>'follow', :as=>'fo_tag'
  get 'follow/unfo_tag/:tag', :action=>'unfo_tag', :controller=>'follow',:as=>'unfo_tag'

  get "/public-timeline", :action=>'publictimeline',:controller=>'index',:as=>'publictimeline'
  
  delete '/timeline/:id',:controller=>'timeline', :action=>'del'

  get '/reg', :controller=>'user',:action=>'reg'
  match "auth/:provider/callback", :to => "user#auth_callback"  

  resources :wishes,:except=>:new do
    collection do
      post 'comment'
      delete 'comment'
      get 'tag/:tag', :action => 'tag', :as => :tag, :constraints  => { :tag => /[^\/]+/ }, :format => false
    end
  end
  
  resources :users, :controller=>'user',:only=>[:create,:show] do 
    resources :spaces
    member do
     # get 'reg'
    end
  end
  
  resources :spaces do
    collection do
      post 'comment'
      delete 'comment'
    end  
  end
  
  resources :topics, :except => [:destroy] do
    resources :replies, :except => [:destroy]
    collection do
      get 'tag/:tag', :action => 'tag', :as => :tag, :constraints  => { :tag => /[^\/]+/ }, :format => false
      get 'mine', :action=>'mine',:as=>:mine
      get 'replied', :action=>'replied', :as=>:replied
      get 'marked', :action=>'marked', :as=>:marked
      get 'interested', :action=>'interested', :as=>:interested
    end
    
    member do
      get :mark
      get :unmark
    end
    
  end
  
  resources :replies
  
  
  controller :sessions do
    get  'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

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
  # root :to => "welcome#index"
  root :to => "index#index", :as=>'index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
