Pairprogram::Application.routes.draw do
  resources :searches, :only => :new
  root :to => "searches#new"

  match 'bids/complete', :to => 'bids#complete', :via => :get, :as => 'complete_bid'
  resources :abuse_reports, :only => :index
  resources :bids do
    resources :offers, :only => [:new, :create, :index]
    resources :abuse_reports, :only => [:new, :create]
  end

  resources :offers, :only => :show
  resources :people, :only => [:edit, :update] do
    member { put :disable }
  end
  resource :dashboard, :only => :show

  resources :logins, :only => :index
  match 'auth/:service/callback', :to => 'logins#callback', :as => 'auth_callback'
  match 'logout', :to => 'logins#destroy'

  resources :resources, :only => :index
end
