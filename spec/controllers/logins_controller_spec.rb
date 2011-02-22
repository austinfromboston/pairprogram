require 'spec_helper'

describe LoginsController do
  AUTH_HASH = {"provider"=>"twitter", 
    "uid"=>"12345", 
    "credentials"=> {
      "token"=>"fake-token-value",
      "secret"=>"fake-secret-value"},
    "user_info"=>{
      "nickname"=>"austinfrmboston", 
      "name"=>"Austin Putman", 
      "location"=>"", 
      "image"=>"http://example.com/foo.jpg",
      "description"=>"", 
      "urls"=>{
        "Website"=>"http://rawfingertips.org", 
        "Twitter"=>"http://twitter.com/austinfrmboston"
      }
    }
  }

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "#callback" do
    before do
      @bid = Factory(:bid)
      @person = Factory(:person)
      request.env['omniauth.auth'] = AUTH_HASH
    end
    def make_request
      get :callback, :service => 'twitter'
    end
    context "when the user is new" do
      it "creates a new identity and person record" do
        session[:pending_bid] = { 'zip' => '55555', 'bidder_attributes' => { 'email' => 'fake@example.com' }}
        lambda {
          lambda { make_request }.should change(Person, :count).by(1)
        }.should change(Identity, :count).by(1)
        new_identity = Identity.last
        new_identity.service.should == 'twitter'
        new_identity.identity_key.should == '12345'
        new_identity.info['nickname'].should == 'austinfrmboston'
      end
    end

    context "when the user is known" do
      before do
        @person.identities.create :service => 'twitter', :identity_key => '12345'
      end
      it "retrieves the existing record" do
        session[:pending_bid] = { 'zip' => 94609, 'bidder_attributes' => {"email" => @person.email} }
        lambda {
          lambda { make_request }.should_not change(Person, :count)
        }.should_not change(Identity, :count)
        controller.current_user.should == @person
      end
      it "stores the user info in the session" do
        make_request
        session[:current_user_id].should == @person.id
      end

      context "when there's a pending bid" do
        it "redirects to complete bid" do
          session[:pending_bid] = { 'zip' => 94609, 'bidder_attributes' => {"email" => "foo@example.com"} }
          make_request
          response.should redirect_to(complete_bid_path)
        end
      end

      context "when there is no pending bid" do
        context "when there is a login target url" do
          it "redirects to the login_target and removes the login target" do
            session[:login_target] = edit_person_url(@person)
            make_request
            response.should redirect_to(edit_person_url(@person))
            session[:login_target].should_not be
          end
        end
        it "redirects to the persons page" do
          make_request
          response.should redirect_to(dashboard_url)
        end
      end
    end
  end
end


