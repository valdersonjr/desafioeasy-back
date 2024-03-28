# Classe Product (Produto).

class Product < ApplicationRecord                                          
    has_many :order_products
    has_many :orders, through: :order_products

    include LikeSearchable                                                 
    include Paginatable                                                    

    validates :name, presence: true, uniqueness: { case_sensitive: false } 
                                                                           
    validates :product_type, presence: true 
                                                                           
    validates :ballast, presence: true, numericality: { greater_than: 0 }  
                                                                           
end
