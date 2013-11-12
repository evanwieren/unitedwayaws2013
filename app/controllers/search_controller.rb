class SearchController < ApplicationController

  def index
    # TODO: Should probably pull the list of categories (other than "All")
    #       from the DB.
    @categories = %w( All BasicNeeds Education General Income )
  end

  def locations
    lat = params[:lat]
    lng = params[:lng]
    cat = params[:category]

    cat = nil if cat == 'All'

    if lat.blank? || lng.blank?
      render status: 500, json: { error: "Both latitude and longitude are required!" }
      return
    end

    # rs = [
    #    {
    #      title:  'The Wynn Golf Club',
    #      desc:   'Lorem ipsum dolor sit amet, consectetur adipisicing elit.',
    #      lat:    36.124981,
    #      lng:    -115.157932,
    #    },
    #    {
    #      title:  'Las Vegas National Golf Club',
    #      desc:   'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis.',
    #      lat:    36.129556,
    #      lng:    -115.125786,
    #    },
    # ]

    rs = Need.all.map(&:to_search)

    render json: rs
  end
end
