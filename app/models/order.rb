class Order < ApplicationRecord
    belongs_to :load
    has_many :order_products
    has_many :products, through: :order_products
end