Rails.application.routes.draw do
  get 'blog/index'
  resources :posts

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'blog#index'
end
