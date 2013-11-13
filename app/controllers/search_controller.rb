class SearchController < ApplicationController

  def index
    puts current_user.name
  end

  def locations
    lat = params[:lat]
    lng = params[:lng]
    radius_in_miles = params[:radius]
    limit = params[:limit] || 10

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

    # 1. select all the needs in the given radius
    # 2. sort the needs based on the user's earlier donations
    needs = find_needs_in_area(lng, lat, radius_in_miles, limit)
    sort_needs_for_user!(needs)

    rs = needs.map(&:to_search)

    render json: rs
  end

  def find_needs_in_area(lng, lat, radius_in_miles, limit)
    Address.collection.find({location: { "$within" => { "$centerSphere" => [[lng, lat], radius_in_miles / 3559.0 ]}}}).limit(limit).map do |address|
      address.agency.needs
    end.flatten.uniq
  end

  def sort_needs_for_user!(needs)
    past_donation_categories = current_user.donations.map(&:category).uniq
    needs.sort_by! { |need| past_donation_categories.index(need.category) || past_donation_categories.size }
  end
end