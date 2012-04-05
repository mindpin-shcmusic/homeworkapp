Quora::Application.routes.draw do
  
  resources :homeworks do
    collection do
      post :create_teacher_attachement
    end
    
    member do
    end
  end
  resources :homeworks, :student

  # -- 用户登录认证相关 --
  root :to=>"index#index"
  get  '/login'  => 'sessions#new'
  post '/login'  => 'sessions#create'
  get  '/logout' => 'sessions#destroy'
  
  get  '/signup'        => 'signup#form'
  post '/signup_submit' => 'signup#form_submit'
end
