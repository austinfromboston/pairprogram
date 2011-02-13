class Offer < ActiveRecord::Base
  belongs_to :sender, :class_name => 'Person'
  belongs_to :bid
  has_one :recipient, :through => :bid, :source => :bidder
  accepts_nested_attributes_for :sender

  after_create :send_notification
  def send_notification
    PersonMailer.offer_email(self).deliver 
  end
end
