require 'spec_helper'

describe DashboardsController do
  describe "GET 'show'" do
    it_should_require_login
    def make_request
      get 'show'
    end
    context "when logged in" do
      before do
        @person = Factory(:person)
        login_as @person
      end
      it "should be successful" do
        make_request
        response.should be_success
        assigns(:person).should == @person
      end
    end
  end

end
