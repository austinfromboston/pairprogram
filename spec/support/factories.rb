Factory.sequence(:email) do |n| 
  "person_#{n}@example.com" 
end
Factory.define :person do |p|
  p.email { Factory.next(:email) }
end
Factory.define :bidder, :class => 'Person' do |p|
  p.email { Factory.next(:email) }
end
Factory.define :superuser, :class => 'Person' do |p|
  p.email { Factory.next(:email) }
  p.superuser true
end
Factory.define :bid do |b|
  b.association(:bidder)
  b.zip '01001'
end
Factory.define :flagged_bid, :class => 'Bid' do |b|
  b.association(:bidder)
  b.after_create { |b| Factory(:abuse_report, :bid => b) }
  b.zip '01001'
end
Factory.define :abuse_report do |r|
  r.association(:bid)
  r.reason "Spam"
end
