class SessionsController < ApplicationController
  def facebook
    #sign_in(User.new)
    redirect_to "/auth/facebook"
  end

  def twitter
    #sign_in(User.new)
    redirect_to "/auth/twitter"
  end

  def donor
    if user = User.where(donor_id: params["donor_id"]).first
      sign_in user
      redirect_to "/search"
    else
      flash[:notice] = "Incorrect ID"
      redirect_to "/"
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
