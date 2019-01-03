Rails.application.routes.draw do
  get 'main/index', to: 'main#index'
  get 'main/new', to: 'main#new'
  root 'main#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
