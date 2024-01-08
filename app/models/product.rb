class Product < ApplicationRecord

    validates :name, presence: true
    validates :ballast, presence: true
end
