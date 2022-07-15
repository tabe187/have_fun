Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  scope module: :public do
    resources :homes, only: [:top, :about]
    root to: 'homes#top'
    
    resources :users, only: [:new, :create]
    
    get     'login',   to: 'sessions#new'
    post    'login',   to: 'sessions#create'
    delete  'logout',  to: 'sessions#destroy'
    
    resources :reservations, only: [:new, :index, :show, :create, :edit, :update, :destroy]
    
  end  
  
end
