class Address < ApplicationRecord
  belongs_to :user

  validates :street, presence: true
  validates :number, presence: true, numericality: { only_integer: true }
  validates :city, presence: true
  validates :state, presence: true
  validates :cep, presence: true, length: { is: 8 }
end
