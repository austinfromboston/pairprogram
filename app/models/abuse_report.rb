class AbuseReport < ActiveRecord::Base
  belongs_to :bid
  scope :visible, includes(:bid) & Bid.visible
end
