class Person < ActiveRecord::Base
  validates_uniqueness_of :email, :name, :allow_blank => true
  validates_presence_of :name
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_blank => true
  has_many :bids, :foreign_key => :bidder_id, :dependent => :destroy
  has_many :offers, :foreign_key => :sender_id, :dependent => :destroy
  has_many :offers_received, :through => :bids, :source => :offers, :dependent => :destroy
  has_many :identities, :dependent => :destroy
  scope :identified_by, lambda { |service, key| 
    includes(:identities).where( :identities => {:service => service, :identity_key => key } ) 
  }

  validate :require_identity

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

  def disable!
    self.update_attribute :disabled, true
    bids.each { |b| b.update_attribute :disabled, true }
  end

  def require_identity
    return unless identities.empty? and email.blank?
    errors.add(:email, "is required")
  end
end
