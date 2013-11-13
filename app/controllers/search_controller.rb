class SearchController < ApplicationController
  #before_filter :signed_in_user
  helper_method :sort_column, :sort_direction

  def index
    # TODO: Should probably pull the list of categories (other than "All")
    #       from the DB.
    @categories = %w( All BasicNeeds Education General Income )
  end

  def locations
    lat = params[:lat]
    lng = params[:lng]
    cat = params[:category]
    sort_query = sort_column + ' ' + sort_direction

    cat = nil if cat == 'All'

    if lat.blank? || lng.blank?
      render status: 500, json: { error: "Both latitude and longitude are required!" }
      return
    end

    #rs = [
    #   {
    #     title:  'The Wynn Golf Club',
    #     desc:   'Lorem ipsum dolor sit amet, consectetur adipisicing elit.',
    #     dist:   0.1,
    #     pop:    2.5,
    #     lat:    36.124981,
    #     lng:    -115.157932,
    #   },
    #   {
    #     title:  'Las Vegas National Golf Club',
    #     desc:   'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis.',
    #     dist:   2.4,
    #     pop:    4.5,
    #     lat:    36.129556,
    #     lng:    -115.125786,
    #   },
    #]

    rs = Need.all.map(&:to_search)

    render json: rs
  end

  private
    def sort_column
      %w[Name Distance Popularity].include?(params[:sort]) ? params[:sort] : 'name'
    end
end
