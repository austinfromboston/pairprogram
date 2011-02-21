class Offer < ActiveRecord::Base
  belongs_to :sender, :class_name => 'Person'
  belongs_to :bid
  has_one :recipient, :through => :bid, :source => :bidder
  accepts_nested_attributes_for :sender
  scope :visible, includes(:bid) & Bid.visible

  after_create :send_notification
  def send_notification
    PersonMailer.offer_email(self).deliver if recipient.allow_email?
  end
end
