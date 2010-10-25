require 'spec_helper'

describe Person do
  it "validates uniqueness of email" do
    p1 = Factory(:person, :email => 'foo@example.com')
    p2 = Factory.build(:person, :email => 'foo@example.com')
    p1.should be_valid
    p2.should_not be_valid
    p2.save
    p2.should be_new_record
  end
  it "validates format of email" do
    p1 = Factory.build(:person, :email => 'foo.example@com')
    p1.should_not be_valid
    p1.save
    p1.should be_new_record

    p2 = Factory(:person, :email => 'foo@example.com')
    p2.should be_valid

  end
end
