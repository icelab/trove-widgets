Rails.application.routes.draw do

  root 'static#index'
  get 'widgets' => 'static#widgets'

end
