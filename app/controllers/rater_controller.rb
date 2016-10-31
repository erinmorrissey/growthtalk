class RaterController < ApplicationController
  def create
    if user_signed_in?
      find_obj
      render json: true
    else
      render json: false
    end
  end

  private

  def find_obj
    obj = params[:klass].classify.constantize.find(params[:id])
    obj.rate params[:score].to_f, current_user, params[:dimension]
  end
end
