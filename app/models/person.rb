class Person < ActiveRecord::Base
  validates_uniqueness_of :email, :name
  validates_presence_of :name
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  has_many :bids

  include Gravtastic
  gravtastic

  before_validation :create_default_name

  def create_default_name
    return unless email
    self.name ||= email[/(^[^@]+)@/, 1]
  end
end
