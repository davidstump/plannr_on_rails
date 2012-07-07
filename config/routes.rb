Plannr::Application.routes.draw do
  resource :canvas, :only => [:show, :create]
  
  # Connect Site
  resource :facebook, :except => :create do
    get :callback, :to => :create
  end
  resource :dashboard, :only => :show
  
  root :to => 'welcome#index'
end
