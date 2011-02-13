require 'spec_helper'

describe OffersController do
  describe "post #create" do
    it "should send email after the offer is created" do
      @bid = Factory(:bid)
      expect {
        post :create, :offer => { :sender_attributes => { :email => 'foo@example.com' }}, :bid_id => @bid.to_param
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
      offer_email = ActionMailer::Base.deliveries.first
      offer_email.subject.should == 'foo is offering to pair with you'
      offer_email.encoded.should =~ /foo@example.com/
    end
  end

end
