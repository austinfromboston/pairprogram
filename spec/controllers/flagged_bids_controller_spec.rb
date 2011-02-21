require 'spec_helper'

describe FlaggedBidsController do
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
        # bid.abuse_reports.create
        login_as current_user
        make_request
        response.should be_success
        assigns[:bids].should_not be_empty
      end
    end
  end
end
