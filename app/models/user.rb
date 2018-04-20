class User < ActiveRecord::Base
  has_secure_password
  has_many :events
  has_many :signups
  has_many :events_attending, through: :signups, source: :event
  has_many :comments

  validates :first_name, :last_name, :email, :location, :state, presence: true  
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+.)+[a-z]+)\z/i
  validates :email, uniqueness: true, :case_sensitive => false, format: {with: EMAIL_REGEX}
  validates :password, length: {minimum: 8}, on: :validation
end
