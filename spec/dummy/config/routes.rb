Rails.application.routes.draw do

  resources :posts

  mount ActiveApi::Engine => "/active_api"
end
