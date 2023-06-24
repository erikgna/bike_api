class User < ApplicationRecord
    attr_accessor :password_confirmation
    validates :name, presence: true, length: { in: 4..60 }
    validates :email, presence: true, uniqueness: true
    validates :password, length: { minimum: 6 }    
    has_many :payments
end
