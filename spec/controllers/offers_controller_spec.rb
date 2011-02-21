require 'spec_helper'

describe OffersController do
  describe "post #create" do
    let(:bid) { Factory(:bid) }

    it "should send email after the offer is created" do
      expect {
        post :create, :offer => { :sender_attributes => { :email => 'foo@example.com' }}, :bid_id => bid.to_param
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
      offer_email = ActionMailer::Base.deliveries.first
      offer_email.subject.should == 'foo is offering to pair with you'
      offer_email.encoded.should =~ /foo@example.com/
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
