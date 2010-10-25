class Bid < ActiveRecord::Base
  belongs_to :person
  has_many :offers
  validates_presence_of :person_id
  attr_accessible :expires_at, :zip

  accepts_nested_attributes_for :person

  before_validation :set_default_expiration, :on => :create

  def set_default_expiration
    self.expires_at ||= 1.day.from_now
  end
end
