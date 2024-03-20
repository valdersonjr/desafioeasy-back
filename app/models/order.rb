class Order < ApplicationRecord
    belongs_to :load
    has_many :order_products, dependent: :destroy
    has_many :products, through: :order_products
    
    include LikeSearchable                                                 
    include Paginatable 

    validates :code, :bay, presence: true
    validates :code, presence: true, uniqueness: { case_sensitive: false }
    validates :load_id, presence: true
    
end