Factory.sequence(:email) do |n| 
  "person_#{n}@example.com" 
end
Factory.define :person do |p|
  p.email { Factory.next(:email) }
end
Factory.define :bidder, :class => 'Person' do |p|
  p.email { Factory.next(:email) }
end
Factory.define :bid do |b|
  b.association(:bidder)
  b.zip '11111'
end
