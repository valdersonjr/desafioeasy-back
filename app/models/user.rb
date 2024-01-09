class User < ApplicationRecord

    validates :name, presence: true
    validates :login, presence: true, uniqueness: { case_sensitive: false }

end
