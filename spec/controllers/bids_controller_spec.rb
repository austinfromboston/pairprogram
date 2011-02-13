require 'spec_helper'

describe BidsController do
  before do
    @bid = Factory(:bid)
    @current_user = Factory(:bidder)
    @bid_attributes = { 'zip' => '90009', 'bidder_attributes' => { 'email' => 'foo@example.com' }} 
  end
  describe "#new" do
    it "should route" do
      {:get => 'bids/new'}.should route_to(:controller => 'bids', :action => 'new')
    end
    it "should render the bid form" do
      get :new
      response.should be_success
      response.should render_template(:new)
    end
    it "should spike the bid with the zip from the params" do
      get :new, :postal_code => '90009'
      assigns[:bid].zip.should == "90009"
    end
  end
  describe "#edit" do
    it "should render" do
      get :edit, :id => @bid.to_param
      response.should be_success
      response.should render_template(:edit)
    end
  end

  describe "#update" do
    context "when the user is logged in" do
      before do
        login_as @current_user
      end
      context "when the data is valid" do
        it "should redirect to the show page" do
          put :update, :id => @bid.to_param, :bid => { :skills => 'None' }
          response.should redirect_to(@bid)
          @bid.reload.skills.should == "None"
        end
      end
      context "when the data is not so good" do
        it "should re-display the edit page" do
          Factory(:bidder, :name => 'foo')
          put :update, :id => @bid.to_param, :bid => { :skills => 'None', :bidder_attributes => { :name => "foo" }}
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
      login_as @current_user
      session[:pending_bid] = @bid_attributes
    end
    it "should create a new bid record populated with values from the session" do
      make_request
      assigns[:bid].attributes['zip'].should == @bid_attributes['zip']
    end
    it "should display the edit bid page" do
      make_request
      response.should render_template(:edit)
    end
  end

  describe "#create" do
    context "when a valid bidderis created" do
      def make_request
        get :create, :bid => @bid_attributes
      end

      context "and the bidder is not logged in" do
        it "should require login" do
          make_request
          response.should redirect_to(logins_path)
        end
        it "should save the in-progress bid data to the session" do
          make_request
          session[:pending_bid].should == @bid_attributes
        end
      end

      context "and the is logged in" do
        before do
          login_as @current_user
        end
        it "should redirect to edit" do
          make_request
          response.should redirect_to(edit_bid_path(Bid.last))
        end

        it "should create a pending bid which expires in one day" do
          lambda { make_request }.should change(Bid, :count).by(1)
          Bid.last.expires_at.to_i.should >= ( 1.day.from_now - 10.seconds ).to_i
          Bid.last.bidder.should  == @current_user
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
        @the_bid = Factory(:bid, :zip => 11111)
        @the_other_bid = Factory(:bid, :zip => 90009) 
        @the_old_bid = Factory(:bid, :zip => 11111, :expires_at => 1.day.ago)
      end
      def make_request
        get :index, :postal_code => '11111'
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
end
