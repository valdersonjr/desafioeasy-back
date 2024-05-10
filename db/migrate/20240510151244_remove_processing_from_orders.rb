class RemoveProcessingFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :processing, :boolean
  end
end
