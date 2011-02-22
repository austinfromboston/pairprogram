require 'spec_helper'

describe AbuseReportsController do
  let(:bid) {Factory(:bid)}

  describe "POST 'create'" do
    it "should redirect to the last search" do
      last_search_url = "http://test.host/foo"
      session[:last_search] = last_search_url
      expect{
        post 'create', :bid_id => bid.to_param, :abuse_report => { :reason => "Spam", :description => "foo" }
      }.to change(AbuseReport, :count).by(1)
      flash[:notice].should match(/Thank you/)
      response.should redirect_to(last_search_url)
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new', :bid_id => bid.to_param
      response.should be_success
    end
  end

end
