class FlaggedBidsController < ApplicationController
  before_filter :check_permission

  def index
    @bids = AbuseReport.visible.all.map(&:bid).uniq
  end

  private

  def check_permission
    return if current_user && current_user.superuser?
    flash[:error] = "I can't show you that, sorry"
    redirect_to current_user ? dashboard_path : root_path
  end
end
