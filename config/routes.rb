Plannr::Application.routes.draw do
  get "dashboards/show"
  get "dashboards/debug"
  
 # Connect Site
  resource :facebook, :except => :create do
    get :callback, :to => :create
  end
  resource :dashboard, :only => [:show, :debug]
  match "dashboard/debug", :controller => 'dashboards', :action => 'debug'

  root :to => 'welcome#index'
end