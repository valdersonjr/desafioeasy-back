json.sorted_order_products do
    json.array! @sorted_order_products, :id, :order_id, :product_id, :layer ,:quantity, :box
  end