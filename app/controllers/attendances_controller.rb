class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  # 残業申請モーダル
  def edit_overtime_request
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    @superior = User.where(superior: true).where.not( id: current_user.id )
  end
  
  def update_overtime_request
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.update_attributes(overtime_params)
      flash[:success] = "残業申請を受け付けました"
      redirect_to user_url(@user)
    end  
  end
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
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
    @superiors = User.where(superior: true).where.not(id: @user.id)
  end
  
  

  def update_one_month
    a_count = 0
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        if item[:attendances_request_superior].present?
          if item[:edit_started_at].blank? && item[:edit_finished_at].present?
            flash[:danger] = "出勤時間が必要です。"
            redirect_to attendances_edit_one_month_user_url(date: params[:date])
            return
          elsif item[:edit_started_at].present? && item[:edit_finished_at].blank?
            flash[:danger] = "退勤時間が必要です。"
            redirect_to attendances_edit_one_month_user_url(date: params[:date])
            return
          elsif item[:edit_started_at].present? && item[:edit_finished_at].present? && item[:edit_started_at].to_s > item[:edit_finished_at].to_s
            flash[:danger] = "時刻に誤りがあります。"
            redirect_to attendances_edit_one_month_user_url(date: params[:date])
            return
          end
          attendance = Attendance.find(id)
          attendance.indicater_reply_edit = "申請中"
          a_count += 1
          attendance.update!(item)
        end
      end
      if a_count > 0
        flash[:success] = "勤怠編集を#{a_count}件、申請しました。"
        redirect_to user_url(date: params[:date])
        return
      else
        flash[:danger] = "上長を選択してください。"
        redirect_to attendances_edit_one_month_user_url(date: params[:date])
        return
      end
    end
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
    return
  end

  private

    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end
    
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end
    end
    
     # 残業申請モーダルの情報
    def overtime_params
      # attendanceテーブルの（残業終了予定時間,翌日、残業内容、指示者確認（どの上長か）、指示者確認（申請かどうか））
      params.require(:attendance).permit(:overtime_finished_at, :tomorrow, :overtime_work,:indicater_check,:indicater_reply)
    end
    
     # 残業申請承認
    def overtime_notice_params
      params.require(:user).permit(attendances: [:indicater_reply, :tommorrow_edit])[:attendances]
    end
end
