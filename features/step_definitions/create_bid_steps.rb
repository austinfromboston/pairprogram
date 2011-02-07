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
  stub_request(:post, "https://api.twitter.com/oauth/request_token").to_return(:status => 200, :body => 'oauth_token=t9zvi1zgCsCkJHmAmPAsYqm47A0RxQX1Mix17xXXXX&oauth_token_secret=GbLzmL41coV6oBQgGJPURqNGAxpEjR2tEM9AXXXX&oauth_callback_confirmed=true', :headers => {})
  stub_request(:post, "https://api.twitter.com/oauth/access_token").to_return(:status => 200, :body => 'oauth_token=12345-Jxq8aYUDRmykzVKrgoLhXSq67TEa5ruc4GJC2rXXXX&oauth_token_secret=J6zix3FfA9LofH0awS24M3HcBYXO5nI1iYe8XXXX&user_id=12345&screen_name=johns', :headers => {})
  stub_request(:get, "https://api.twitter.com/1/account/verify_credentials.json").to_return(:status => 200, :body => '{"provider": "twitter", "uid":"5", "user_info":{"screen_name": "johns", "name": "John Smith", "location": "Tokyo", "profile_image_url": "", "description": "", "url": ""}', :headers => {})
end

When /I should see the twitter auth link/ do
  find_link('Twitter')['href'].should == "/auth/twitter"
end
