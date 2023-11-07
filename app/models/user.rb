class User < ApplicationRecord
    validates :username, presence: true, length: { minimum: 6, maximum: 100 }
    validates :email, presence: true, length: { minimum: 6, maximum: 1000 }
end