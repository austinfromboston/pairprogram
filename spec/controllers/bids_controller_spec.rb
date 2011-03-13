require 'spec_helper'

describe BidsController do
  let(:current_user) { Factory(:bidder) }
  let(:bid) { Factory(:bid, :bidder => current_user) }
  let(:bid_attributes) {{ 'zip' => '90009', 'bidder_attributes' => { 'email' => 'foo@example.com' }}}

  describe "#new" do
    it "should route" do
      {:get => 'bids/new'}.should route_to(:controller => 'bids', :action => 'new')
    end
    render_views
    it "should render the bid form" do
      make_fixture('new_bid') do
        get :new
      end
      response.should be_success
      response.should render_template(:new)
    end
    it "should spike the bid with the zip from the params" do
      get :new, :postal_code => '90009'
      assigns[:bid].zip.should == "90009"
    end
    it "should spike the bid with the lat/lon from the params" do
      get :new, :latitude => '40', :longitude => '-120'
      assigns[:bid].latitude.should == 40
      assigns[:bid].longitude.should == -120
    end
  end

  describe "#edit" do
    it_should_require_login
    def make_request
      get :edit, :id => bid.to_param
    end
    it "should render" do
      login_as current_user
      make_request
      response.should be_success
      response.should render_template(:edit)
    end
  end

  describe "#update" do
    context "when the user is logged in" do
      before do
        login_as current_user
      end
      context "when the data is valid" do
        it "should redirect to the show page" do
          put :update, :id => bid.to_param, :bid => { :skills => 'None' }
          response.should redirect_to(dashboard_path)
          bid.reload.skills.should == "None"
        end
      end
      context "when the data is not so good" do
        it "should re-display the edit page" do
          Factory(:bidder, :name => 'foo')
          put :update, :id => bid.to_param, :bid => { :skills => 'None', :bidder_attributes => { :name => "foo" }}
          response.should render_template(:edit)
        end
      end
    end
  end
  describe "#complete" do
    it_should_require_login
    def make_request
      get :complete
    end
    before do
      login_as current_user
      session[:pending_bid] = bid_attributes
    end
    it "should create a new bid record populated with values from the session" do
      make_request
      assigns[:bid].attributes['zip'].should == bid_attributes['zip']
    end
    it "should display the edit bid page" do
      make_request
      response.should render_template(:edit)
    end
    it "should drop the pending bid from the session" do
      make_request
      session[:pending_bid].should_not be
    end
  end

  describe "#create" do
    context "when a valid bidder is created" do
      def make_request
        get :create, :bid => bid_attributes
      end

      context "and the bidder is not logged in" do
        it "should require login" do
          make_request
          response.should redirect_to(logins_path)
        end
        it "should save the in-progress bid data to the session" do
          make_request
          session[:pending_bid].should == bid_attributes
        end
      end

      context "and the bidder is logged in" do
        let(:bid_attributes) {{ 'zip' => '90009', 'bidder_attributes' => { 'id' => current_user.to_param, 'email' => 'foo@example.com' }}}
        before do
          login_as current_user
        end
        it "should redirect to edit" do
          make_request
          response.should redirect_to(edit_bid_path(Bid.last))
        end

        it "should create a pending bid which expires in one day" do
          lambda { make_request }.should change(Bid, :count).by(1)
          Bid.last.expires_at.to_i.should >= ( 1.day.from_now - 10.seconds ).to_i
          Bid.last.bidder.should  == current_user
        end

        it "should update the email of the bidder" do
          current_user.email.should_not == 'foo@example.com'
          make_request
          current_user.reload.email.should == 'foo@example.com'
        end
      end
    end
  end

  describe "#index" do
    it "should route" do
      { :get => "/bids" }.should route_to(:controller => 'bids', :action => 'index')
    end

    context "when matching bids are found" do
      before do
        @the_bid = Factory(:bid, :zip => '01001', :latitude => 42.0899887, :longitude => -72.61588)
        @the_other_bid = Factory(:bid, :zip => 90009) 
        @the_old_bid = Factory(:bid, :zip => '01001', :expires_at => 1.day.ago)
      end
      def make_request(params={})
        get :index, { :postal_code => '01001' }.merge(params)
      end
      it "should display the page" do
        make_request
        response.should be_success
        response.should render_template("index")
      end

      it "should assign a list of matching bids" do
        make_request
        assigns[:bids].should include(@the_bid)
        assigns[:bids].should_not include(@the_other_bid)
      end

      it "should not show expired bids" do
        make_request
        assigns[:bids].should_not include(@the_old_bid)
      end

      it "should record the search url in the session" do
        make_request
        session[:last_search].should == "http://test.host/bids?postal_code=01001"
      end

      context "when searching by geolocation" do
        it "should find nearby bids" do
          make_request :postal_code => nil, :latitude => '42.0898', :longitude=> '-72.6157'
          assigns[:bids].should include(@the_bid)
          assigns[:bids].should_not include(@the_other_bid)
        end
      end
    end

    context "when no results are found" do
      it "should render the bidding page" do
        get :index, :postal_code => 'f1o 1b1'
        response.should be_redirect
        flash[:notice].should match(/no pairs/i)
      end
      it "should put the search value in the params" do
        get :index, :postal_code => '50005'
        response.should redirect_to(new_bid_path(:postal_code => '50005'))
      end
    end

    context "when the zip code isn't valid" do
      it "should redirect back to the new searches page" do
        get :index, :postal_code => ""
        response.should redirect_to(new_search_path)
      end
      it "should also redirect back to the new searches page" do
        get :index, :postal_code => "zzb"
        response.should redirect_to(new_search_path)
      end
      it "should put a message in the flash" do
        get :index, :postal_code => "zzb"
        flash[:notice].should match('US and Canadian postal codes')
      end
    end
  end

  describe "destroy" do
    def make_request
      delete :destroy, :id => bid.id
    end
    context "login behavior" do
      it_should_require_login
    end

    context "when logged in" do
      before do
        login_as current_user
      end

      it "should not allow users to destroy bids that dont belong to them" do
        bid.bidder = Factory(:bidder)
        bid.save
        expect{
          expect{ make_request }.to raise_error(ActiveRecord::RecordNotFound)
        }.not_to change(Bid, :count)
      end

      context "when the bid belongs to the current user" do
        it "destroys the bid and returns to the dashboard" do
          current_user.bids.should include(bid)
          expect{ make_request }.to change(current_user.bids, :count)
          response.should redirect_to(dashboard_url)
          flash[:notice].should == "Posting removed"
        end
      end

    end
  end
end
