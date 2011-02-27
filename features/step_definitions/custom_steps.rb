When /^I wait (\d+\.?\d?) seconds$/ do |time|
  sleep time.to_f
end

Given /^the following bids:$/ do |bids|
  Bid.create!(bids.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) bid$/ do |pos|
  visit bids_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following bids:$/ do |expected_bids_table|
  expected_bids_table.diff!(tableish('table tr', 'td,th'))
end

Given /^these bids$/ do |bid_data|
  bid_data.hashes.each do |row|
    person = Person.find_or_create_by_email row['email']
    person.bids.create! :zip => row['zip']
  end
end

Given /there is data/ do
  puts Bid.count, " bids from #{Person.all.map(&:email).join(", ")}"
end

When /I prepare to auth via (\w+)/ do |service|
  OmniAuth.config.mock_auth[service.underscore.to_sym] = {
    'uid' => '123545',
    'provider' => service.underscore,
    'user_info' => {
      'name' => 'fake user'
    }
  }
end

When /I should see the twitter auth link/ do
  find_link('Twitter')['href'].should == "/auth/twitter"
end

Then /\"([^\"]+)\" should receive an offer email from \"([^\"]+)\"/ do |bidder, person_offering|
  offer_email = ActionMailer::Base.deliveries.first
  offer_email.should_not be_nil
  offer_email.subject.should == "#{person_offering} is offering to pair with you" 
  offer_email.encoded.should =~ /To stop receiving these messages/
end

When /I am logged in as ([@\.\w]+)/ do |email|
  steps  %Q[
    When I am the returning user #{email}
    Then I prepare to auth via twitter
    And I am on the logins page
    And I follow "Twitter"
  ]
end

When /I am the returning user ([@\.\w]+)/ do |email|
  user = Person.find_or_create_by_email email
  user.identities.find_or_create_by_service_and_identity_key 'twitter', '123545'
end

When /I am the disabled user ([@\.\w]+)/ do |email|
  user = Person.find_or_create_by_email email
  user.identities.find_or_create_by_service_and_identity_key 'twitter', '123545'
  user.disable!
end

When /I am the admin/ do
  user = Person.find_or_create_by_email "admin@example.com"
  user.update_attribute :superuser, true
  steps  %Q[
    When I am the returning user admin@example.com
    Then I prepare to auth via twitter
    And I am on the logins page
    And I follow "Twitter"
  ]
end

Given /^these flagged bids$/ do |bid_data|
  bid_data.hashes.each do |row|
    person = Person.find_or_create_by_email row['email']
    bid = person.bids.create! :zip => row['zip']
    bid.abuse_reports.create! :reason => "Spam"
  end
end

When /I should be editing the bid/ do 
  current_url.should =~ /\/bids\/\d+\/edit$/
end
