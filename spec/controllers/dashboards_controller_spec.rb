require 'spec_helper'

describe DashboardsController do
  describe "GET 'show'" do
    let(:current_user) { Factory(:person) }

    it_should_require_login

    def make_request
      get 'show'
    end
  end

end
