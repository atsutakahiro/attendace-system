class BasesController < ApplicationController
  before_action :set_base, only: [:destroy, :edit, :update]
  
  def index
    @bases = Base.all
    @base = Base.new
  end
  
  def edit
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = "拠点情報を追加しました。"
      redirect_to bases_url
    else
      render :_form
    end
  end
  
  def destroy
    @base.destroy
    flash[:success] = "拠点情報を削除しました。"
    redirect_to bases_url
  end
  
  def update
    if @base.update_attributes(base_params)
      flash[:success] = "拠点情報を更新しました。"
      redirect_to bases_url
    else
      render :edit
    end
  end
  
  


  private
    def set_base
      @base = Base.find(params[:id])
    end
  
    def base_params
      params.require(:base).permit(:base_num, :base_name, :kinds)
    end
end   