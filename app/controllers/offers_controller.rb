class OffersController < ApplicationController
  before_filter :find_bid, :only => [:new, :create, :index]
  def new
    @offer = Offer.new
  end
  def create
    @offer = @bid.offers.build params[:offer]
    if @offer.save
      redirect_to @offer
    else
      render 'new'
    end
  end

  protected 
  def find_bid
    @bid = Bid.find params[:bid_id]
  end
end
