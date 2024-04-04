class SortedOrderProduct < ApplicationRecord
    belongs_to :order
    belongs_to :product

    validates :quantity, :layer, presence: true, numericality: { greater_than: 0 }
    validates :product_id, :order_id, presence: true
    validates :box, inclusion: { in: [true, false] }
  end