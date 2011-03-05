require 'spec_helper'

describe LocationsController do
  describe "#GET index" do
    it "should return a location name based on a geolocation" do
      # TODO fix this with real dummy data
      stub(Geocoder::Lookup).address('40', '-110') do
        { 'city' => 'Winnepeg',
          'state' => 'Manitoba',
          'country' => 'Canada' }
      end
      get :index, :latitude => '40', :longitude => '-110', :format => :json
      response.should be_success
      JSON.parse(response.body)['location'].should == 'Winnepeg, Manitoba, Canada'
    end
  end
end
