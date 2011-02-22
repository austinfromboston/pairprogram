class AbuseReportsController < ApplicationController
  before_filter :check_permission, :only => :index

  def index
    @bids = AbuseReport.visible.all.map(&:bid).uniq
  end

  def create
    @bid = Bid.find params[:bid_id]
    @abuse_report = @bid.abuse_reports.build params[:abuse_report]
    if @abuse_report.save
      flash[:notice] = "Thank you, I'll review your report shortly"
      redirect_to session[:last_search] || :back
    else
      render :new
    end

  end

  def new
    @bid = Bid.find params[:bid_id]
    @abuse_report = @bid.abuse_reports.build
  end

  private

  def check_permission
    return if current_user && current_user.superuser?
    flash[:error] = "I can't show you that, sorry"
    redirect_to current_user ? dashboard_path : root_path
  end
end
