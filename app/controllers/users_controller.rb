class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :update_index, :destroy, :edit_basic_info, :update_basic_info, :show_check]
  before_action :logged_in_user, only: [:edit, :update, :update_index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:show, :edit, :update,]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info, :all_user_edit]
  before_action :admin_impossible, only: :show
  before_action :set_one_month, only: [:show, :show_check]

  def index
    @users = User.paginate(page: params[:page])
    @users = @users.where('name LIKE ?', "%#{params[:search]}%") if params[:search].present?
  end
  
  # def self.search(search)
  #   if search
  #     User.where('title LIKE(?)', "%#{search}%")
  #   else
  #     User.all
  #   end
  # end
  
  # def search
  #   @users = User.search(params[:name])
  # end
  
   
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    @overtime_count = Attendance.where(indicater_check: @user.name, indicater_reply: "申請中").count
    @change = Attendance.where(indicater_reply_edit: "申請中", indicater_check_edit: @user.name).count
    @month = Attendance.where(indicater_reply_month: "申請中", indicater_check_month: @user.name).count
    @superiors = User.where(superior: true).where.not(id: @user.id )
    @month_approval_count = Attendance.where(one_month_request_superior: @user.name).count
    @month_change_count = Attendance.where(indicater_select: "申請中", indicater_request: @user.name).count
    
    # csv出力
    respond_to do |format|
      format.html
      filename = @user.name + "：" + l(@first_day, format: :middle) + "分" + " " + "勤怠"
      format.csv { send_data render_to_string, type: 'text/csv; charset=shift_jis', filename: "#{filename}.csv" }
    end
  end
  def update_index
    # debugger
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to users_url
    else
      flash[:danger] = "更新に失敗しました。"
      redirect_to users_url
    end 
  end 
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定
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

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def all_user_edit
  end

  def edit_basic_info
  end
  
  def working 
    # ユーザーモデルから全てのユーザーに紐づいた勤怠たちを代入
    @users = User.all.includes(:attendances)
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  def show_check
    @worked_sum = @attendances.where.not(started_at: nil).count
    @overtime_count = Attendance.where(indicater_check: @user.name, indicater_reply: "申請中").count
    @change = Attendance.where(indicater_reply_edit: "申請中", indicater_check_edit: @user.name).count
    @month = Attendance.where(indicater_reply_month: "申請中", indicater_check_month: @user.name).count
    @superiors = User.where(superior: true).where.not(id: @user.id )
  end

  private
  # "ここに書いてあるのがストロングパラメーターという"

    def user_params
      params.require(:user).permit(:name, :email, :affiliation,:employee_number,:uid, :password, 
        :password_confirmation, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end

    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
    end
end

