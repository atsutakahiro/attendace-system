class BasesController < ApplicationController
  
  
  def index
    @bases = Base.all
    @base = Base.new
  end
  
  def edit
  end
end

private

    def set_base
      @base = Base.find(params[:id])
    end
