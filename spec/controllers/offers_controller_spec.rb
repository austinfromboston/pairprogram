require 'spec_helper'

describe OffersController do
  describe "post #create" do
    let(:bid) { Factory(:bid) }

    context "when a referer is available" do
      it "should redirect back to the prior page" do
        original_url = 'http://test.host/foo'
        request.env['HTTP_REFERER'] = original_url
        post :create, :offer => { :sender_attributes => { :email => 'foo@example.com' }}, :bid_id => bid.to_param
        flash[:notice].should == "Pairing request sent"
        response.should redirect_to(original_url)
      end
    end

    it "should redirect to the new search page" do
      post :create, :offer => { :sender_attributes => { :email => 'foo@example.com' }}, :bid_id => bid.to_param
      flash[:notice].should == "Pairing request sent"
      response.should redirect_to(root_url)
    end

    it "should send email after the offer is created" do
      expect {
        post :create, :offer => { :sender_attributes => { :email => 'foo@example.com' }}, :bid_id => bid.to_param
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
      offer_email = ActionMailer::Base.deliveries.first
      offer_email.subject.should == 'foo is offering to pair with you'
      offer_email.encoded.should =~ /foo@example.com/
    end

    context "when the current_user is logged in" do
      before do
        @current_user = Factory(:person)
        login_as @current_user
      end
      it "should create an offer record for the current user" do
        expect {
          post :create, :bid_id => bid.to_param
        }.to change(@current_user.offers, :count)
      end
    end

    context "when the bidder does not want email" do
      it "should send nothing" do
        bid.bidder.update_attribute :allow_email, false
        expect {
          post :create, :offer => { :sender_attributes => { :email => 'foo@example.com' }}, :bid_id => bid.to_param
        }.to_not change(ActionMailer::Base.deliveries, :size)
      end
    end
  end

end
