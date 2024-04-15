class OrderProduct < ApplicationRecord
    belongs_to :order
    belongs_to :product
  
    validates :quantity, presence: true, numericality: { greater_than: 0 }
    validates :box, inclusion: { in: [true, false] }
    validates :product_id, presence: true
  end