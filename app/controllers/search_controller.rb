class SearchController < ApplicationController

  def index
    puts current_user.name
  end

  def locations
    lat = params[:lat]
    lng = params[:lng]
    radius_in_miles = params[:radius]

    if lat.blank? || lng.blank?
      render status: 500, json: { error: "Both latitude and longitude are required!" }
      return
    end

    # rs = [
    #   {
    #     title:  'The Wynn Golf Club',
    #     desc:   'Lorem ipsum dolor sit amet, consectetur adipisicing elit.',
    #     lat:    36.124981,
    #     lng:    -115.157932,
    #   },
    #   {
    #     title:  'Las Vegas National Golf Club',
    #     desc:   'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis.',
    #     lat:    36.129556,
    #     lng:    -115.125786,
    #   },
    # ]

    needs = Address.collection.find({location: { "$within" => { "$centerSphere" => [[lng, lat], radius_in_miles / 3559.0 ]}}}).map do |address|
      address.agency.needs
    end.flatten.uniq

    rs = needs.map(&:to_search)

    render json: rs
  end
end