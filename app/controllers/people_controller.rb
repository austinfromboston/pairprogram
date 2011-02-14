class PeopleController < ApplicationController
  def show
  end

  def edit
    @person = Person.find params[:id]
  end

  def update
    @person = Person.find params[:id]
    if @person.update_allowed_attributes params[:person]
      flash[:notice] = "Updated your info"
      redirect_to @person
    else
      render :edit
    end
  end
end
