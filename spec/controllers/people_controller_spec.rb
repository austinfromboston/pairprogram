require 'spec_helper'

describe PeopleController do
  let(:current_user) { Factory(:person) }
  let(:haxor) { Factory(:person) }

  describe "GET #edit" do
    it_should_require_login
    def make_request
      get :edit, :id => current_user.to_param
    end
    it "should be successful" do
      login_as current_user
      make_request
      response.should be_success
    end
    context "when not logged in" do
      it "should store the login_target in the session before redirecting" do
        make_request
        session[:login_target].should == edit_person_url(current_user)
        response.should redirect_to(logins_path)
      end
    end
    context "when logged in as another user" do
      it "should not allow access to edit personal data" do
        login_as haxor
        make_request
        response.should redirect_to(dashboard_url)
        flash[:error].should == "I can't show you that, sorry"
      end

    end
  end

  describe "PUT #disable" do
    let(:person) { Factory :person }
    let(:bid) { Factory :bid, :bidder => person }

    def make_request
      put :disable, :id => person.to_param
    end
    it "should disable the targeted user" do
      login_as Factory(:superuser)
      make_request
      person.reload.should be_disabled
      response.should redirect_to(flagged_bids_path)
      flash[:notice].should == "That's the last we'll hear of #{person.name}"
    end
  end

  describe "PUT #update" do
    it_should_require_login
    def make_request
      put :update, :person => { :allow_email => "false" }, :id => current_user.to_param
    end
    context "when logged in" do
      before do
        login_as current_user
      end
      it "should change preferences" do
        current_user.allow_email.should be_true
        make_request
        response.should redirect_to(dashboard_url)
        current_user.reload.allow_email.should_not be_true
      end

      it "should not allow changes of names or email addresses" do
        original_name = current_user.name
        original_email = current_user.email
        put :update, :person => { :email => "vaz@example.com", :name => 'user_foo!' }, :id => current_user.to_param
        current_user.name.should == original_name
        current_user.email.should == original_email
      end

      context "when logged in as another user" do
        it "should not allow access to edit personal data" do
          login_as haxor
          make_request
          response.should redirect_to(dashboard_url)
          flash[:error].should == "I can't show you that, sorry"
        end
      end
    end
  end
end
