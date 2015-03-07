Rails.application.routes.draw do

  root 'static#index'
  get 'examples', to: 'static#examples', as: :examples

  namespace :widgets do
    get 'preload', to: 'preload#index'
    get 'summary/state', to: 'summary#state'
    get 'summary/single', to: 'summary#single'
    get 'summary/multiple', to: 'summary#multiple'
    get 'summary/statesearch', to: 'summary#statesearch'
    get 'navigator/title', to: 'navigator#title'
    get 'usage/state', to: 'usage#state'
    get 'usage/single', to: 'usage#single'
    get 'usage/multiple', to: 'usage#multiple'
  end

end
