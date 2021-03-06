require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

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
      def make_fixture(fixture_name)
        raise "a block containing a mock request is needed to make a fixture" unless block_given?
        yield
        if response.body.blank?
          raise "Body is blank for #{fixture_name}. Perhaps you should render_views?"
        end
        doc = Nokogiri.parse(response.body)
        doc.search('script, [rel=stylesheet]').each { |node| node.remove }
        doc.search('img').each { |node| node.remove_attribute('src') }
        Dir.mkdir('tmp/jasmine-dom-fixtures') unless File.exist?('tmp/jasmine-dom-fixtures')
        File.open("tmp/jasmine-dom-fixtures/#{fixture_name}.html", 'w') do |f|
          f.print doc.to_html
        end
      end
    }, :type => :controller)
    config.extend(Module.new {
          def it_should_require_login(options={})
            it "should redirect to logins page if user is not logged in" do
              session[:current_user_id] = nil
              make_request
              response.should redirect_to(logins_path)
            end

            it "should not redirect if user is logged in" do
              @test_login_user = @current_user || (respond_to?(:current_user) && current_user) || Factory(:person)
              session[:current_user_id] = @test_login_user.id
              make_request
              response.should_not redirect_to(logins_path)
            end
          end
    }, :type => :controller)
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

end

# --- Instructions ---
# - Sort through your spec_helper file. Place as much environment loading 
#   code that you don't normally modify during development in the 
#   Spork.prefork block.
# - Place the rest under Spork.each_run block
# - Any code that is left outside of the blocks will be ran during preforking
#   and during each_run!
# - These instructions should self-destruct in 10 seconds.  If they don't,
#   feel free to delete them.
#




