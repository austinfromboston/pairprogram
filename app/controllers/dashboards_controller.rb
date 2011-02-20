class DashboardsController < ApplicationController
  before_filter :require_login
  def show
    @person = current_user
  end

end
