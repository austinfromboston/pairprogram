class LocationsController < ApplicationController
  def index
    address = Geocoder::Lookup.address(params[:latitude], params[:longitude])
    render :json => { :location => "#{address['city']}, #{address['state']}, #{address['country']}"}
  end
end
