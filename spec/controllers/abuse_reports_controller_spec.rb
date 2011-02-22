require 'spec_helper'

describe AbuseReportsController do
  let(:bid) {Factory(:bid)}

  describe "POST 'create'" do
    it "should be successful" do
      referer = "http://test.host/current_bid_search"
      request.env['HTTP_REFERER'] = referer
      expect{
        post 'create', :bid_id => bid.to_param, :abuse_report => { :reason => "Spam", :description => "foo" }
      }.to change(AbuseReport, :count).by(1)
      flash[:notice].should match(/Thank you/)
      response.should redirect_to(referer)
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new', :bid_id => bid.to_param
      response.should be_success
    end
  end

end
