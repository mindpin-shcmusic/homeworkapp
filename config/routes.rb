Quora::Application.routes.draw do
  
  resources :homeworks do
    collection do
      post :create_teacher_attachement
    end
    
    member do
    end
  end
  # 老师查看某一学生作业路由
  get 'homeworks/:homework_id/student/:user_id' => 'homeworks#student'
  
  resources :student do
    collection do
      post :upload_homework_attachement
      post :upload_homework_attachement_again
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
