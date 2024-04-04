class CreateSortedOrderProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :sorted_order_products do |t|
      t.integer :layer
      t.integer :quantity
      t.boolean :box
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
