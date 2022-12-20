class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :set_user_id, only: [:update, :edit_overtime_request, :edit_overtime_notice, :update_overtime_request, :update_overtime_notice, :update_month_approval, :edit_month_approval, :edit_month_change]
  before_action :logged_in_user, only: [:update, :edit_one_month, :update_one_month, :edit_log]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: [:edit_one_month]
  before_action :set_attendance, only: [:update, :edit_overtime_request, :update_overtime_request, :update_month_request]
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してださい。"
  NO_CHECK_ERROR_MSG = "変更にチェックがないものは更新できません。"
  INVALID_ERROR_MSG = "無効な入力があった為、更新をキャンセルしました"

  # 残業申請モーダル
  def edit_overtime_request
    @superiors = User.where(superior: true).where.not(id: @user.id )
  end
  
  def update_overtime_request
    if overtime_request_params[:overtime_finished_at].blank? || overtime_request_params[:business_process_content].blank? || overtime_request_params[:indicater_check].blank?
      flash[:success] = "終了予定時間、業務処理内容、または、指示者確認㊞がありません。"
    else
      if overtime_request_params[:overtime_finished_at].present? && overtime_request_params[:business_process_content].present? && overtime_request_params[:indicater_check].present?
        params[:attendance][:indicater_reply] = "申請中"
        @attendance.update(overtime_request_params)
        flash[:success] = "残業申請をしました"
      else
        flash[:danger] = "残業申請が正しくありません"
      end
    end
    redirect_to @user
  end
  
  def update
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end

  def edit_one_month
    @superiors = User.where(superior: true).where.not(id: @user.id )
  end
  
  # １ヶ月分の勤怠を更新します
  def update_one_month
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        if (item)[:started_edit_at].present? || (item)[:finished_edit_at].present?
          if (item)[:indicater_request].present? && (item)[:note].present?
            attendance.indicater_select = "申請中" 
            attendance.update_attributes!(item)
          else 
            flash[:danger] = "申請箇所には出社、退社、備考、指示者確認㊞が必要です。"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
          end
        end
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新・申請しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = INVALID_ERROR_MSG
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  def edit_overtime_notice
    @attendances = Attendance.where(indicater_check: @user.name, indicater_reply: "申請中").order(:worked_on).group_by(&:user_id)
  end
  
  # 残業申請のお知らせモーダルウィンドウ更新
  def update_overtime_notice
    overtime_notice_params.each do |id, item|
      attendance = Attendance.find(id)
      if item[:tomorrow_edit] == "1"
        if item[:indicater_reply] == "なし"
          attendance.overtime_finished_at = nil
          attendance.tomorrow = nil
          attendance.business_process_content = nil
          attendance.indicater_check = nil
        end
        attendance.update(item)
        flash[:success] = "勤怠の変更申請を送信しました。"
      else
        flash[:danger] = "残業申請の承認に失敗しました。" 
      end
    end
    redirect_to user_url
  end
  
  # １ヶ月の勤怠申請
  def update_month_request
    month_request_params.each do |id, item|
      attendance = Attendance.find(id)
      if item[:one_month_request_superior].present?
        item[:one_month_approval_status] = "申請中"
        if attendance.update(item)
          flash[:success] = "勤怠申請を送信しました"
        else 
          flash[:danger] = "勤怠申請を送信できませんでした。"
        end  
      else
        flash[:danger] = "所属長を選択してください"
      end
    end
    redirect_to user_url
  end
  
  # 上長による１ヶ月分の勤怠提出の決済
  def edit_month_approval
    @attendances = Attendance.where(one_month_request_superior: @user.name).order(:worked_on).group_by(&:user_id)
  end
  
  def update_month_approval
    ActiveRecord::Base.transaction do
      month_approval_params.each do |id, item|
        attendance = Attendance.find(id)
        if item[:one_month_approval_check] == "1"
          attendance.update_attributes!(item)
        else
          flash[:danger] = NO_CHECK_ERROR_MSG
        end
      end
    end
    flash[:success] = "勤怠変更の決済を更新しました。"
    redirect_to user_url
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = INVALID_ERROR_MSG
    redirect_to user_url
  end
  
  # 上長による勤怠変更の決済
  def edit_month_change
    @attendances = Attendance.where(indicater_request: @user.name, indicater_select: "申請中").order(:worked_on).group_by(&:user_id)
  end
  
  def update_month_change
    ActiveRecord::Base.transaction do
      month_change_params.each do |id, item|
        attendance = Attendance.find(id)
        if params[:user][:attendances][id][:month_change] == "1"
          attendance.update_attributes!(item)
        else
          flash[:danger] = NO_CHECK_ERROR_MSG
        end
      end
    end
    flash[:success] = "勤怠変更の決済を更新しました。"
    redirect_to user_url
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = INVALID_ERROR_MSG
    redirect_to user_url
  end
  
  def edit_log
    @indicater_select_approval = Attendance.where(indicater_select: "承認").order(:worked_on)
  end
  

        
        
      
        
          
        
    
  
  
  private
  
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end
    end

    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :started_edit_at, :started_before_at, :finished_at, :finished_edit_at, :finished_before_at, :note, :next_day, :indicater_request])[:attendances]
    end
    
     # 残業申請モーダルの情報
    def overtime_request_params
      params.require(:attendance).permit([:overtime_finished_at, :tomorrow, :business_process_content, :indicater_check, :indicater_reply])
    end
    
     # 残業申請承認
    def overtime_notice_params
      params.require(:user).permit(attendances: [:indicater_reply, :tomorrow_edit])[:attendances]
    end
    
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end
    
    def month_request_params
      params.require(:user).permit(attendances: [:one_month_request_superior, :one_month_approval_status])[:attendances]
    end
    
    def month_change_params
      params.require(:user).permit(attendances: [:indicater_select])[:attendances]
    end
    
    def month_approval_params
      params.require(:user).permit(attendances: [:one_month_approval_check])[:attendances]
    end
end
