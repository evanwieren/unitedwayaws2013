class StaticPageController < ApplicationController
  def index
    @body_class = "login"
    if signed_in?
      redirect_to search_path
    end
  end
end
