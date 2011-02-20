class Person < ActiveRecord::Base
  validates_uniqueness_of :email, :name
  validates_presence_of :name
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  has_many :bids, :foreign_key => :bidder_id
  has_many :offers, :foreign_key => :sender_id
  has_many :identities
  scope :identified_by, lambda { |service, key| 
    includes(:identities).where( :identities => {:service => service, :identity_key => key } ) 
  }

  include Gravtastic
  gravtastic

  before_validation :create_default_name, :on => :create
  before_validation :setup_preferences, :on => :create

  def create_default_name
    return unless email
    self.name ||= email[/(^[^@]+)@/, 1]
  end

  def setup_preferences
    self.allow_email = true
  end

  def update_allowed_attributes(values)
    update_attributes values.delete_if { |key, value| !['allow_email'].include?(key) }
  end
end
