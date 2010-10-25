class BidsController < ApplicationController
  def new
    @bid = Bid.new :zip => params[:postal_code]
    @bid.build_person
  end

  def create
    @bid = Bid.new params[:bid]
    @bid.person = find_bid_person
    if @bid.save
      redirect_to(@bid)
    else
      render :new
    end
  end

  def show
    @bid = Bid.find params[:id]
  end

  def index
    @bids = Bid.where(:zip => params[:postal_code]).where(["expires_at >= ?", Time.now])
    if @bids.empty?
      flash[:notice] = "No pairs available in your area today, leave us your email so we can notify you when someone else wants to pair"
      redirect_to new_bid_path(:postal_code => params[:postal_code])
    end
  end

  protected

  def find_bid_person
    bidder_email = params[:bid] && params[:bid][:person_attributes] && params[:bid][:person_attributes][:email]
    return unless bidder_email
    Person.find_or_create_by_email bidder_email
  end

end
