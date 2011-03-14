class BidsController < ApplicationController
  before_filter :store_bid, :only => :create
  before_filter :require_login, :only => [ :create, :edit, :update, :complete, :destroy ]

  def new
    bid_attributes = {:zip => bid_params[:postal_code], :latitude => bid_params[:latitude], :longitude => bid_params[:longitude]} if bid_params
    @bid = Bid.new(bid_attributes || {})
    @bid.bidder = current_user || @bid.build_bidder
  end

  def create
    @bid = current_user.bids.build
    @bid.attributes = params[:bid]
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
    if search_params[:postal_code].present? || ( search_params[:latitude].blank? )
      unless LocationValidator.accepts?(search_params[:postal_code])
        flash[:notice] = 'This only works with US and Canadian postal codes.  Patches welcome!'
        redirect_to new_search_path and return
      end
      @bids = Bid.visible.where(:zip => search_params[:postal_code])
    else
      @bids = Bid.visible.near([search_params[:latitude].to_f, search_params[:longitude].to_f], 25).all
    end

    if @bids.present?
      session[:last_search] = request.url
    else
      flash[:notice] = "No pairs are available in your area right now. If you leave your email, we can notify you when someone in your area wants to pair. Your email will not be used for anything else."
      redirect_to new_bid_path(:bid => search_params.select { |k, v| v.present? })
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

  def search_params
    params[:search]
  end

  def bid_params
    params[:bid]
  end

  protected

  def store_bid
    session[:pending_bid] = params[:bid] unless current_user
  end

end
