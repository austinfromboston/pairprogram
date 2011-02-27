class OffersController < ApplicationController
  before_filter :find_bid, :only => [:new, :create, :index]
  def new
    @offer = Offer.new
  end
  def create
    @offer = @bid.offers.build params[:offer]
    @offer.sender = current_user if current_user
    if @offer.save
      flash[:notice] = "Pairing request sent"
      redirect_to session[:last_search] || :back
    else
      render 'new'
    end
  end

  protected
  def find_bid
    @bid = Bid.find params[:bid_id]
  end
end
