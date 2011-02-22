class LoginsController < ApplicationController
  before_filter :require_login, :only => :destroy

  def index
  end

  def callback
    auth_info = request.env['omniauth.auth']
    user = Person.identified_by(auth_info['provider'], auth_info['uid']).first || create_person(auth_info)
    return kick_them_out if user.disabled?

    session[:current_user_id] = user.id
    redirect_to complete_bid_url and return if session[:pending_bid]
    redirect_to session.delete(:login_target) || dashboard_url
  end

  def destroy
    session[:current_user_id] = nil
    flash[:notice] = "Logged out.  Happy soloing."
    redirect_to root_path
  end

  protected

  def create_person(auth_info)
    person = Person.new :name => auth_info['user_info']['name'], :email => session[:pending_bid]['bidder_attributes']['email']
    person.identities.build :service => auth_info['provider'], :identity_key => auth_info['uid'], :info => auth_info['user_info']
    person.save!
    person
  end

  def kick_them_out
    flash[:error] = "Your account has been disabled. Please post no further messages here."
    redirect_to root_path
  end
end
