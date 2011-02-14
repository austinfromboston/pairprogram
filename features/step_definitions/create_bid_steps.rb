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
    person.bids.create :zip => row['zip']
  end
end

Given /there is data/ do
  puts Bid.count, " bids from #{Person.all.map(&:email).join(", ")}"
end

When /I prepare to auth via (\w+)/ do |service|
  OmniAuth.config.mock_auth[:twitter] = {
    'uid' => '123545',
    'provider' => 'twitter',
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

