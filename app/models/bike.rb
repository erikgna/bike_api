class Bike < ApplicationRecord
    validates :model, presence: true
    validates :name, presence: true
    validates :avaliability, default: true, presence: true
end
