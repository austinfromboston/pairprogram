class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    Person.find_by_id session[:current_user_id]
  end
end
