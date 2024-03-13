class OrderProduct < ApplicationRecord
    belongs_to :order
    belongs_to :product

    include LikeSearchable                                                 
    include Paginatable

    validates :order_id, :product_id, :quantity, presence: true
    validates :box, inclusion: { in: [true, false] }
    validates :order, :product, presence: true
end