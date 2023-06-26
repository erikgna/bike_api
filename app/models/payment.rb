class Payment < ApplicationRecord
  validates :holder_name, presence: true, length: { in: 4..60 }
  validates :card_number, presence: true, uniqueness: true, length: { in: 16..16 }
  validates :expiration_date, presence: true, length: { in: 4..4 }
  validates :ccv, presence: true, length: { in: 3..3 }
  belongs_to :user  
end
