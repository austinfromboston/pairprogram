Pairprogram::Application.routes.draw do
  resources :searches, :only => :new 
  root :controller => 'searches', :action => 'new'

  match 'bids/complete', :to => 'bids#complete', :via => :get, :as => 'complete_bid'
  resources :bids do
    resources :offers, :only => [:new, :create, :index]
    resources :abuse_reports, :only => [:new, :create, :index]
  end

  resources :offers, :only => :show
  resources :resources, :only => :index
  resources :logins, :only => :index
  resources :people, :only => [:edit, :update]
  resource :dashboard, :only => :show
  match 'auth/:service/callback', :to => 'logins#callback', :as => 'auth_callback'
  match 'logout', :to => 'logins#destroy'
end
