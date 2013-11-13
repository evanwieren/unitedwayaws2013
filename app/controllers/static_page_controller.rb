class StaticPageController < ApplicationController
  def index
    @body_class = "login"
    unless signed_in?
      redirect_to search_path
    end
  end

  def about

  end

end
