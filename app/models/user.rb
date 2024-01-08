class User < ApplicationRecord

    validates :name, presence: true
    validates :login, presence: true
    validates :password, presence: true
end
