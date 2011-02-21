class BidsController < ApplicationController
  before_filter :store_bid, :only => :create
  before_filter :require_login, :only => [ :create, :edit, :update, :complete, :destroy ]

  def new
    @bid = Bid.new :zip => params[:postal_code]
    @bid.build_bidder
  end

  def create
    @bid = Bid.new params[:bid]
    @bid.bidder = current_user
    if @bid.save
      redirect_to(edit_bid_path(@bid))
    else
      render :new
    end
  end

  def complete
    @bid = Bid.new session[:pending_bid]
    @bid.bidder = current_user
    @bid.save
    session.delete :pending_bid
    render :edit
  end

  def show
    @bid = Bid.find params[:id]
  end

  def index
    unless LocationValidator.accepts?(params[:postal_code])
      flash[:notice] = 'This only works with US and Canadian postal codes.  Patches welcome!'
      redirect_to new_search_path and return
    end
    @bids = Bid.where(:zip => params[:postal_code]).where(["expires_at >= ?", Time.now])
    if @bids.empty?
      flash[:notice] = "No pairs are available in your area right now. If you leave your email, we can notify you when someone in your area wants to pair. Your email will not be used for anything else."
      redirect_to new_bid_path(:postal_code => params[:postal_code])
    end
  end

  def edit
    @bid = current_user.bids.find(params[:id])
  end

  def update
    @bid = current_user.bids.find(params[:id])
    @bid.attributes = params[:bid]
    if @bid.bidder.save && @bid.save
      flash[:notice] = "We'll let you know when a pair becomes available"
      redirect_to(dashboard_path)
    else
      flash[:error] = "There are some problems with your description"
      render :edit
    end
  end

  def destroy
    @bid = current_user.bids.find(params[:id])
    @bid.destroy
    flash[:notice] = "Posting removed"
    redirect_to dashboard_url
  end

  protected

  def store_bid
    session[:pending_bid] = params[:bid] unless current_user
  end

end
