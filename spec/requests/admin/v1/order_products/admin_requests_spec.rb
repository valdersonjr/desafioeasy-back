require 'rails_helper'

RSpec.describe "Admin V1 OrderProducts as :admin", type: :request do
  let(:user) { create(:user) }
  before do
    allow_any_instance_of(Admin::V1::OrderProductsController).to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(Admin::V1::OrderProductsController).to receive(:current_user).and_return(user)
  end
  let!(:load) { create(:load) }
  let!(:order) { create(:order) }
  let!(:product) { create(:product) }
  let!(:order_products) { create(:order_product) }
  
  describe "GET /order_products" do
    let(:url) { "/admin/v1/loads/#{load.id}/orders/#{order.id}/order_products" }
    let!(:order_products) { create_list(:order_product, 5, order: order) }

    it "lists all products for the specified order" do
      get url, headers: auth_header(user)

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.count).to eq(5)

    end
  end

  describe "POST /order_products" do
    let(:url) { "/admin/v1/loads/#{load.id}/orders/#{order.id}/order_products" }
    context "with valid params" do
      let(:order_product_params) do
        { order_product: attributes_for(:order_product, product_id: product.id, order_id: order.id) }.to_json
      end

      it "adds a new product to the order" do
        expect do
          post url, headers: auth_header(user), params: order_product_params
        end.to change(order.order_products, :count).by(1)
      end

      it "returns the added product" do
        post url, headers: auth_header(user), params: order_product_params
        expected_order_product = OrderProduct.last.as_json(only: %i(id product_id order_id quantity box))
        expect(body_json['order_product']).to eq expected_order_product
      end

      it "returns success status" do
        post url, headers: auth_header(user), params: order_product_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:order_product_invalid_params) do 
        { order_product: attributes_for(:order_product, order_id: nil) }.to_json
      end

      it 'does not add a new Order Products' do
        expect do
          post url, headers: auth_header(user), params: order_product_invalid_params
        end.to_not change(OrderProduct, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: order_product_invalid_params
        expect(body_json).to have_key('fields')
        if body_json['fields'].present?
          expect(body_json['fields']).to have_key('product')
        else
          puts "No 'fields' key in body_json"
        end
      end
      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: order_product_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /order_products/:id" do
    let!(:order_product) { create(:order_product, order: order, product: product) }
    let(:url) { "/admin/v1/loads/#{load.id}/orders/#{order.id}/order_products/#{order_product.id}" }

    context "with valid params" do
      let(:new_quantity) { 3 }
      let(:order_product_params) { { order_product: { quantity: new_quantity } }.to_json }

      it "updates the product in the order" do
        patch url, headers: auth_header(user), params: order_product_params
        order_product.reload
        expect(order_product.quantity).to eq new_quantity
      end

      it "returns success status" do
        patch url, headers: auth_header(user), params: order_product_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:order_product_invalid_params) do 
        { order_product: attributes_for(:order_product, order_id: nil) }.to_json
      end

      it 'does not update Order Products' do
        old_order_id = order_product.order.id
        patch url, headers: auth_header(user), params: order_product_invalid_params
        order_product.reload
        expect(order_product.order.id).to eq old_order_id
      end

      it 'returns error message' do
        patch url, headers: auth_header(user), params: order_product_invalid_params
        expect(body_json).to have_key('fields')
        if body_json['fields'].present?
          expect(body_json['fields']).to have_key('order')
        else
          puts "No 'fields' key in body_json"
        end
      end

      it 'returns unprocessable_entity status' do
        patch url, headers: auth_header(user), params: order_product_invalid_params
        expect(body_json).to have_key('fields')
        if body_json['fields'].present?
          expect(response).to have_http_status(:unprocessable_entity)
        else
          puts "No 'fields' key in body_json"
        end
      end
    end
  end
  describe "DELETE /order_products/:id" do
    let!(:order_product) { create(:order_product, order: order, product: product) }
    let(:url) { "/admin/v1/loads/#{load.id}/orders/#{order.id}/order_products/#{order_product.id}" }

    it "removes the product from the order" do
      expect do
        delete url, headers: auth_header(user)
      end.to change(OrderProduct, :count).by(-1)
    end

    it "returns success status" do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end
  end
end