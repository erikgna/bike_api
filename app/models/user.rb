class User < ApplicationRecord
    validates :name, presence: true, length: { in: 4..60 }
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true
end
