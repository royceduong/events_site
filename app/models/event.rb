class Event < ActiveRecord::Base
  belongs_to :user
  has_many :signups
  has_many :users_attending, through: :signups, source: :user
  has_many :comments

  validates :name, :date, :location, :state, presence: true  
  validate :date_cannot_be_in_past

  def date_cannot_be_in_past
    errors.add(:date, "must be in the future") unless date > Date.today
  end
end
