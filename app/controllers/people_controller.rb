class PeopleController < ApplicationController
  before_filter :require_login, :check_permission

  def edit
    @person = Person.find params[:id]
  end

  def update
    @person = Person.find params[:id]
    if @person.update_allowed_attributes params[:person]
      flash[:notice] = "Updated your info"
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  def disable
    @person = Person.find params[:id]
    @person.disable!
    flash[:notice] = "That's the last we'll hear of #{@person.name}"
    redirect_to flagged_bids_path
  end

  private

  def check_permission
    return if current_user && (params[:id] == current_user.to_param || current_user.superuser?)
    flash[:error] = "I can't show you that, sorry"
    redirect_to dashboard_path
  end
end
