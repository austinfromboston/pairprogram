require 'spec_helper'

describe LocationsController do
  describe "#GET index" do
    it "should return a location name based on a geolocation" do
     stub_request(:get, "http://maps.google.com/maps/api/geocode/json?latlng=40,-110&sensor=false").
       with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => File.read('spec/fixtures/geo_response.json'), :headers => {})
      get :index, :latitude => '40', :longitude => '-110', :format => :json
      response.should be_success
      JSON.parse(response.body)['location'].should == 'Adana, Adana, Turkey'
    end

    context "when offline" do
      it "should send a notification to the user" do
        stub(Geocoder::Lookup).search('40', '-110') { nil }
        get :index, :latitude => '40', :longitude => '-110', :format => :json
        response.should be_success
        JSON.parse(response.body)['error'].should == 'Sorry, I can\'t look up your location'
      end
    end
  end
end
