class OffersController < ApplicationController
  before_filter :find_bid, :only => [:new, :create, :index]
  rescue_from ActionController::RedirectBackError, :with => :send_to_dashboard
  def new
    @offer = Offer.new
  end
  def create
    @offer = @bid.offers.build params[:offer]
    if @offer.save
      flash[:notice] = "Pairing request sent"
      redirect_to :back
    else
      render 'new'
    end
  end

  protected
  def find_bid
    @bid = Bid.find params[:bid_id]
  end

  def send_to_dashboard
    redirect_to new_search_path
  end
end
