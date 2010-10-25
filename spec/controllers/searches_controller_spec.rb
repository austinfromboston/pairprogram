require 'spec_helper'

describe SearchesController do
  describe "#new" do
    it "should route" do
      { :get => "/searches/new" }.should route_to(:controller => 'searches', :action => 'new' )
      { :get => "/" }.should route_to(:controller => 'searches', :action => 'new' )
    end

    it "should display the new search page" do
      get :new
      response.should be_success
      response.should render_template("new")
    end
  end
end
