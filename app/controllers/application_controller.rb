class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    Person.find_by_id session[:current_user_id]
  end

  def require_login
    return if current_user
    session[:auth_target] = request.path
    redirect_to logins_path
  end

end
