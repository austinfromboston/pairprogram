require 'spec_helper'

describe PeopleController do
  before do
    @person = Factory(:person)
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :id => @person.to_param
      response.should be_success
    end
  end

  describe "GET #edit" do
    it "should be successful" do
      get :edit, :id => @person.to_param
      response.should be_success
    end
  end

  describe "PUT #update" do
    it "should change preferences" do
      @person.allow_email.should be_true
      put :update, :person => { :allow_email => "false" }, :id => @person.to_param
      response.should redirect_to(person_path)
      @person.reload.allow_email.should_not be_true
    end

    it "should not allow changes of names or email addresses" do
      original_name = @person.name
      original_email = @person.email
      put :update, :person => { :email => "vaz@example.com", :name => 'user_foo!' }, :id => @person.to_param
      @person.name.should == original_name
      @person.email.should == original_email
    end
  end
end
