class User < ApplicationRecord
    attr_accessor :password_confirmation
    validates :first_name, presence: true, length: { in: 4..40 }
    validates :last_name, presence: true, length: { in: 4..40 }
    validates :cpf, presence: true, length: { is: 11 }, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :password, length: { minimum: 6 }            
    
    has_many :payments
    has_many :rides
    has_many :addresses
end
