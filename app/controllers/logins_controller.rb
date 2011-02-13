class LoginsController < ApplicationController
  def index
  end

  def callback
    auth_info = request.env['omniauth.auth']
    user = Person.identified_by(auth_info['provider'], auth_info['uid']).first || create_person(auth_info)

    session[:current_user_id] = user.id
    redirect_to complete_bid_path and return if session[:pending_bid]
    redirect_to person_path(current_user)
  end

  protected

  def create_person(auth_info)
    person = Person.new :name => auth_info['user_info']['name'], :email => session[:pending_bid]['bidder_attributes']['email']
    person.identities.build :service => auth_info['provider'], :identity_key => auth_info['uid'], :info => auth_info['user_info']
    person.save!
    person
  end
end
