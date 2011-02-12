require 'spec_helper'

describe Bid do
  before do
    stub_request(:get, "http://maps.google.com/maps/api/geocode/json?address=11111&sensor=false").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => File.read('spec/fixtures/geo_response.json'), :headers => {})
  end
  it "should have a geographical location" do
    bid = Factory(:bid)
    bid.fetch_coordinates!
    bid.latitude.should_not be_nil
    bid.longitude.should_not be_nil
  end
end
