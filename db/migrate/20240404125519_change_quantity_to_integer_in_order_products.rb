class ChangeQuantityToIntegerInOrderProducts < ActiveRecord::Migration[7.0]
  def up
    change_column :order_products, :quantity, 'integer USING CAST(quantity AS integer)'
  end

  def down
    change_column :order_products, :quantity, :string
  end
end