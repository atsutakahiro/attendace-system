Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      get 'all_user_edit' 
      get 'edit_basic_info'
      patch 'update_basic_info'
      patch 'update_index'
      get 'attendances/edit_one_month' # この行が追加対象です。
      patch 'attendances/update_one_month'
      # １ヶ月の勤怠申請
      patch 'attendances/update_one_month_request'
    end
  resources :attendances, only: [:update] do
      member do
        # 残業申請モーダル
        get 'edit_overtime_request'
        patch 'update_overtime_request'  
        # 残業承認
        get 'edit_overtime_notice'
        patch 'update_overtime_notice'
      end
  end
  end
end