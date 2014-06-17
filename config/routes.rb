Rails.application.routes.draw do

  root 'static#index'
  get 'widgets', to: 'static#widgets'
  get 'widgets/summary', to: 'widgets#summary'

end
