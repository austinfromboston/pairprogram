require 'spec_helper'

describe Person do
  before do
    @person = Factory(:person)
  end
  it "validates uniqueness of name and email" do
    p1 = Factory(:person, :email => 'foo@example.com', :name => 'foo')
    p2 = Factory.build(:person, :email => 'foo@example.com')
    p1.should be_valid
    p2.should_not be_valid
    p2.save
    p2.should be_new_record

    p3 = Factory.build(:person, :name => 'foo')
    p3.should_not be_valid
  end
  it "validates format of email" do
    p1 = Factory.build(:person, :email => 'foo.example@com')
    p1.should_not be_valid
    p1.save
    p1.should be_new_record

    p2 = Factory(:person, :email => 'foo@example.com')
    p2.should be_valid

  end
  it "should have a gravatar" do
    @person.gravatar_url.should_not be_nil
  end
  it "defaults to the first segment of email for the name" do
    @person.name.should match(/person_\d/)
  end
  it "should require a name" do
    @person.name = ""
    @person.email = ""
    @person.valid?
    @person.errors[:name].should have(1).error
  end
  it "has many identities" do
    @person.identities.create :service => 'twitter', :identity_key => '12345'
    Person.identified_by(:twitter, '12345').first.should == @person
  end
end
