class LocationsController < ApplicationController
  def index
    results = Geocoder::Lookup.search(params[:latitude], params[:longitude])
    if results
      address = results.first
      city = address.address_components.find { |c| c["types"].any? { |t| t == "locality"}}
      state = address.address_components.find { |c| c["types"].any? { |t| t == "administrative_area_level_1"}}
      country = address.address_components.find { |c| c["types"].any? { |t| t == "country"}}
      response = { :location => [ city, state, country ].map { |level| level && level['long_name'] }.compact.join(", ") }
    else
      response = { :error => 'Sorry, I can\'t look up your location' }
    end
    render :json => response
  end
end
