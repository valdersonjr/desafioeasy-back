class Product < ApplicationRecord

    include LikeSearchable
    include Paginatable

    validates :name, presence: true, uniqueness: { case_sensitive: false }
    
    validates :ballast, presence: true
    validates :ballast, presence: true, numericality: { greater_than: 0 }

end
