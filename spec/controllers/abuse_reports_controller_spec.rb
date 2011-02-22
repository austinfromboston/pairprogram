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

  describe "GET #index" do
    def make_request; get :index; end

    context "when the user is not logged in" do
      it "redirects to root" do
        make_request
        response.should redirect_to(root_path)
      end
    end
    context "when the user is not superuser" do
      let(:current_user) { Factory(:person) }
      it "redirects to dashboard" do
        login_as current_user
        make_request
        response.should redirect_to(dashboard_path)
        flash[:error].should == "I can't show you that, sorry"
      end
    end
    context "when the user is superuser" do
      let(:current_user) { Factory(:superuser) }
      it "should be successful" do
        bid = Factory(:flagged_bid)
        login_as current_user
        make_request
        response.should be_success
        assigns[:bids].should_not be_empty
      end
    end
  end
end
