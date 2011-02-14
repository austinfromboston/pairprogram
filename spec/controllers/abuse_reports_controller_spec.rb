require 'spec_helper'

describe AbuseReportsController do
  before do
    @bid = Factory(:bid)
  end

  describe "POST 'create'" do
    it "should be successful" do
      expect{
        post 'create', :bid_id => @bid.to_param, :abuse_report => { :reason => "Spam", :description => "foo" }
      }.to change(AbuseReport, :count).by(1)
      flash[:notice].should match(/Thank you/)
      response.should redirect_to(root_path) 
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new', :bid_id => @bid.to_param
      response.should be_success
    end
  end

end
