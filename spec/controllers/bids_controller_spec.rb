require 'spec_helper'

describe BidsController do
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
  describe "#create" do
    context "when a valid person is created" do
      def make_request
        get :create, :bid => { :zip => '90009', :person_attributes => { :email => 'foo@example.com' }} 
      end
      it "should redirect to show" do
        make_request
        response.should redirect_to(bid_path(Bid.last))
      end

      it "should create a bid which expires in one day" do
        lambda { make_request }.should change(Bid, :count).by(1)
        Bid.last.expires_at.to_i.should >= ( 1.day.from_now - 10.seconds ).to_i
      end

      context "if the person record doesn't exist" do
        it "should create a person record" do
          lambda { make_request }.should change(Person, :count).by(1)
        end
      end
      context "if the person record does exist" do
        before do
          @person = Factory(:person, :email => 'foo@example.com')
        end
        it "should reuse the person record" do
          lambda { 
            lambda { make_request }.should_not change(Person, :count)
          }.should change(@person.bids(true), :count).by(1)

        end
      end
      context "when an invalid person is created" do
        def make_request
          get :create, :bid => { :zip => '90009', :person_attributes => { :email => 'foo.example.com' }}
        end
        it "should render the new bid form with errors" do
          make_request
          response.should be_success
          response.should render_template('new')
          assigns[:bid].person.should have_at_least(1).errors
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
        get :index, :postal_code => 'foo'
        response.should be_redirect
        flash[:notice].should match(/no pairs/i)
      end
      it "should put the search value in the params" do
        get :index, :postal_code => '50005'
        response.should redirect_to(new_bid_path(:postal_code => '50005'))
      end
    end
  end
end
