Rails.application.routes.draw do

  root 'static#index'

  namespace :widgets do
    get 'preload', to: 'preload#index'
    get 'summary/single', to: 'summary#single'
    get 'summary/multiple', to: 'summary#multiple'
    get 'summary/state', to: 'summary#state'
    get 'summary/statesearch', to: 'summary#statesearch'
    get 'navigator/title', to: 'navigator#title'
  end

end
