require 'spec_helper'

describe Bid do
  it "should have a geographical location" do
    bid = Factory(:bid)
    bid.fetch_coordinates!
    bid.latitude.should_not be_nil
    bid.longitude.should_not be_nil
  end
end
