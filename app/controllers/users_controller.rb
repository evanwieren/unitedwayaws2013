class UserController < ApplicationController

	def attend
      attendance = Attendance.find_or_create_by(user_id: params[:user_id], need_id: params[:need_id])
	end

	def remove
	  attendance = Attendance.find_or_create_by(user_id: params[:user_id], need_id: params[:need_id])
	  attendance.destroy
	end
end