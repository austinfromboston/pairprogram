class AbuseReportsController < ApplicationController
  def create
    @bid = Bid.find params[:bid_id]
    @abuse_report = @bid.abuse_reports.build params[:abuse_report]
    if @abuse_report.save
      flash[:notice] = "Thank you, I'll review your report shortly"
      redirect_to root_path
    else
      render :new
    end

  end

  def index
  end

  def new
    @bid = Bid.find params[:bid_id]
    @abuse_report = @bid.abuse_reports.build
  end

end
