ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
Bundler.require(:development)
require 'webmock/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  config.mock_with :rr
  #config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true
  DatabaseCleaner.strategy = :truncation
  config.before do
    DatabaseCleaner.clean
  end
  config.include(Module.new {
    def login_as(user)
      session[:current_user_id] = user.id
    end
  }, :type => :controller)
  config.extend(Module.new {
        def it_should_require_login
          it "should redirect to logins page if user is not logged in" do
            session[:current_user_id] = nil
            make_request
            response.should redirect_to(logins_path)
          end

          it "should not redirect if user is logged in" do
            @test_login_user = Factory(:person)
            session[:current_user_id] = @test_login_user.id
            make_request
            response.should_not redirect_to(logins_path)
          end
        end
  }, :type => :controller)
end
