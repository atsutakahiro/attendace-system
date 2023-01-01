Rails.application.routes.draw do
  get 'bases/index'

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :bases, only: [:edit, :create, :destroy, :index, :update] 
  
  resources :users do
    member do
      get 'all_user_edit' 
      get 'edit_basic_info'
      patch 'update_basic_info'
      patch 'update_index'
      get 'attendances/edit_one_month' # この行が追加対象です。
      patch 'attendances/update_one_month'
      # １ヶ月の勤怠申請
      patch 'attendances/update_month_request'
      # 勤怠確認
      get 'show_check'
      # 勤怠編集ログ
      get 'attendances/edit_log'
      
      get 'commuter'
    end
    collection { post :import }
    resources :attendances, only: [:update] do
      member do
        # 残業申請モーダル
        get 'edit_overtime_request'
        patch 'update_overtime_request'  
        
        # 残業承認
        get 'edit_overtime_notice'
        patch 'update_overtime_notice'
        
        # １ヶ月の勤怠変更承認
        get 'edit_month_change'
        patch 'update_month_change'
        
        # １ヶ月の残業承認
        get 'edit_month_approval'
        patch 'update_month_approval'
      end
    end
  end
end