ActionController::Routing::Routes.draw do |map|
  
  map.from_plugin APP_CONFIG[:app_name] + "_engine" if APP_CONFIG[:use_engine_plugin]

  # non-localized routes
  map.resource :session

  map.with_options :path_prefix => '/:locale' do |localized|

    #Restful Authentication
    localized.logout '/logout', :controller => 'sessions', :action => 'destroy'
    localized.login '/login', :controller => 'sessions', :action => 'new'
    localized.register '/register', :controller => 'users', :action => 'create'
    localized.signup '/signup', :controller => 'users', :action => 'new'
    localized.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
    localized.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
    localized.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
    
    localized.resources :users, :passwords, :roles, :images, :documents
    localized.resources :comments, :collection => { :destroy_multiple => :delete},
                  :member => { :approve => :put, :reject => :put }
    localized.resources :pages do |page|
      page.resources :components
      page.resources :articles, :as => "content"
      page.resources :newsitems, :as => "latest", :collection => {:archive => :get}
      page.resources :posts, :as => "posts", :collection => {:archive => :get}
      page.resources :events, :as => "list"
    end
    
    # Search
    localized.search 'search', :controller => "search", :action => "index"
   
    # Calendar Mapping
    localized.browse 'pages/:page_id/browse/:month/:year', :controller => 'events', :action => 'index'
    
    # News Archive Mapping
    localized.archive 'pages/:page_id/archive/:month/:year', :controller => 'newsitems', :action => 'archive'
    localized.annual_archive 'pages/:page_id/archive/:year', :controller => 'newsitems', :action => 'archive'
    
    # Blog Archive Mapping
    localized.blog_archive 'pages/:page_id/archived/:month/:year', :controller => 'posts', :action => 'archive'
    localized.blog_annual_archive 'pages/:page_id/archived/:year', :controller => 'posts', :action => 'archive'
  end

  map.home "", :controller => "articles", :page_id => "1"
  map.root :home
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
