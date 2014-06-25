Rails.application.routes.draw do

  root 'static#index'

  namespace :widgets do
    get 'summary/single', to: 'summary#single'
    get 'summary/multiple', to: 'summary#multiple'
    get 'summary/state', to: 'summary#state'
    get 'navigator/title', to: 'navigator#title'
  end

end
