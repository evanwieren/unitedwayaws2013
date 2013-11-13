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

  def show

  end
end