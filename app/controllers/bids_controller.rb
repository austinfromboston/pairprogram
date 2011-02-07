class BidsController < ApplicationController
  before_filter :store_bid, :only => :create
  before_filter :require_login, :only => [ :create, :update, :complete ]

  def new
    @bid = Bid.new :zip => params[:postal_code]
    @bid.build_person
  end

  def create
    @bid = Bid.new params[:bid]
    @bid.person = current_user
    if @bid.save
      redirect_to(edit_bid_path(@bid))
    else
      render :new
    end
  end

  def complete
    @bid = Bid.new session[:pending_bid]
    @bid.person = current_user
    @bid.save
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
    @bid = Bid.find(params[:id])
  end

  def update
    @bid = Bid.find(params[:id])
    @bid.attributes = params[:bid]
    if @bid.person.save && @bid.save
      redirect_to(@bid)
    else
      flash[:error] = "There are some problems with your description"
      render :edit
    end
  end

  protected

  def require_login
    return if current_user
    session[:auth_target] = request.path
    redirect_to logins_path 
  end

  def store_bid
    session[:pending_bid] = params[:bid] unless current_user
  end

end
