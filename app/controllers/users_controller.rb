class UsersController < ApplicationController

	def attend
    attendance = Attendance.find_or_create_by(user_id: params[:id], need_id: params[:need_id])
    redirect_to :back
	end

	def remove
	  attendance = Attendance.find_or_create_by(user_id: params[:id], need_id: params[:need_id])
	  attendance.destroy
    redirect_to :back
  end

  def tweet
    need = Need.where(nid: params[:need_id]).first
    need.twitter_post(current_user)
  end

  def show

  end
end