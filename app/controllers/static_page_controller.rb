class StaticPageController < ApplicationController
  def index
    if signed_in?
      redirect_to search_path
    end
  end

  def about

  end

end
