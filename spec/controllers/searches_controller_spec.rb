require 'spec_helper'

describe SearchesController do
  describe "#new" do
    it "should route" do
      { :get => "/searches/new" }.should route_to(:controller => 'searches', :action => 'new' )
      { :get => "/" }.should route_to(:controller => 'searches', :action => 'new' )
    end

    render_views
    it "should display the new search page" do
      make_fixture('new_search') do
        get :new
      end
      response.should be_success
      response.should render_template("new")
    end
  end
end
