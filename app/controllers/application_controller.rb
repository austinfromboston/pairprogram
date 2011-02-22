class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from ActionController::RedirectBackError, :with => :send_to_dashboard

  def current_user
    Person.find_by_id session[:current_user_id]
  end

  protected

  def require_login
    return if current_user
    session[:login_target] = request.url
    redirect_to logins_path
  end

  def send_to_dashboard
    redirect_to dashboard_url and return if current_user
    redirect_to root_url
  end
end
