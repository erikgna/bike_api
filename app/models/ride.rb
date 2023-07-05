class Ride < ApplicationRecord
  validates :start_date, presence: true
  validates :start_location, presence: true
  validates :last_four_digits, length: { is: 4 }, allow_nil: true
  
  belongs_to :user
end
