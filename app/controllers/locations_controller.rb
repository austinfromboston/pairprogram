class LocationsController < ApplicationController
  def index
    address = Geocoder::Lookup.address(params[:latitude], params[:longitude])
    response = address && { :location => "#{address['city']}, #{address['state']}, #{address['country']}"}
    response ||= { :error => 'Sorry, I can\'t look up your location' }
    render :json => response
  end
end
