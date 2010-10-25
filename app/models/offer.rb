class Offer < ActiveRecord::Base
  belongs_to :person
  belongs_to :bid
  accepts_nested_attributes_for :person
end
