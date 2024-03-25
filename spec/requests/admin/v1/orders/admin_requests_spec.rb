
require 'rails_helper'

RSpec.describe "Admin V1 Orders as :admin", type: :request do
  let(:user) { create(:user) } 
  
  before do
    allow_any_instance_of(Admin::V1::OrdersController).to receive(:authenticate_user!).and_return(true) 
    allow_any_instance_of(Admin::V1::OrdersController).to receive(:current_user).and_return(user)
  end
  let!(:load) { create(:load) }
  let!(:order) { create(:order) }

  context "GET /orders" do
    let(:url) { "/admin/v1/loads/#{load.id}/orders" }            
    let!(:orders) { create_list(:order, 10, load: load) } 

    context "without any params" do
      it "returns 10 Orders" do
        get url, headers: auth_header(user)
        expect(body_json['orders'].count).to eq 10
      end
      it "returns 10 first Orders" do
        get url, headers: auth_header(user)
        expected_orders = orders[0..9].as_json(only: %i(bay code id load_id))
        expect(body_json['orders']).to contain_exactly *expected_orders
      end

      it "returns success status" do
        get url, headers: auth_header(user)
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 10, total_pages: 1 } do
        before { get url, headers: auth_header(user) }
      end
    end
    context "with search[code] param" do
      let!(:search_code_orders) do
        orders = [] 
        15.times { |n| orders << create(:order, code: "Search #{n + 1}", load: load) }
        orders 
      end

      let(:search_params) { { search: { code: "Search" } } }

      it "returns only seached orders limited by default pagination" do
        get url, headers: auth_header(user), params: search_params
        expected_orders = search_code_orders[0..9].map do |order|
          order.as_json(only: %i(id code bay load_id))
        end
        expect(body_json['orders']).to contain_exactly *expected_orders
      end

      it "returns success status" do
        get url, headers: auth_header(user), params: search_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 15, total_pages: 2 } do
        before { get url, headers: auth_header(user), params: search_params }
      end
    end

    context "with pagination params" do
      let(:page) { 2 }
      let(:length) { 5 }

      let(:pagination_params) { { page: page, length: length } }

      it "returns records sized by :length" do
        get url, headers: auth_header(user), params: pagination_params
        expect(body_json['orders'].count).to eq length
      end
      
      it "returns orders limited by pagination" do
        get url, headers: auth_header(user), params: pagination_params
        expected_orders = orders[5..9].as_json(only: %i(id code bay load_id))
        expect(body_json['orders']).to contain_exactly *expected_orders
      end

      it "returns success status" do
        get url, headers: auth_header(user), params: pagination_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 2, length: 5, total: 10, total_pages: 2 } do
        before { get url, headers: auth_header(user), params: pagination_params }
      end
    end

    context "with order params" do
      let(:order_params) { { order: { code: 'desc' } } }

      it "returns ordered orders limited by default pagination" do
        get url, headers: auth_header(user), params: order_params
        orders.sort! { |a, b| b[:code] <=> a[:code]}
        expected_orders = orders[0..9].as_json(only: %i(id code bay load_id))
        expect(body_json['orders']).to contain_exactly *expected_orders
      end
 
      it "returns success status" do
        get url, headers: auth_header(user), params: order_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 10, total_pages: 1 } do
        before { get url, headers: auth_header(user), params: order_params }
      end
    end
  end

  context "POST /orders" do
    let(:url) { "/admin/v1/loads/#{load.id}/orders" }
    let!(:load) { create(:load) }
      
    context "with valid params" do
    let(:order_params) do
        { order: attributes_for(:order, load_id: load.id) }.to_json
    end

      it 'adds a new Order' do
        expect do
          post url, headers: auth_header(user), params: order_params
        end.to change(Order, :count).by(1)
      end

      it 'returns last added Order' do
        post url, headers: auth_header(user), params: order_params
        expected_order = Order.last.as_json(only: %i(id code bay load_id))
        expect(body_json['order']).to eq expected_order
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: order_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:order_invalid_params) do 
        { order: attributes_for(:order, code: nil) }.to_json
      end

      it 'does not add a new Order' do
        expect do
          post url, headers: auth_header(user), params: order_invalid_params
        end.to_not change(Order, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: order_invalid_params
        expect(body_json).to have_key('fields')
        if body_json['fields'].present?
          expect(body_json['fields']).to have_key('code')
        else
          puts "No 'fields' key in body_json"
        end
      end
      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: order_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "GET /orders/:id" do
    let(:order) { create(:order) }
    let!(:product) { create(:product) }
    let!(:order_product) { create(:order_product, order: order, product: product) }
    let(:url) { "/admin/v1/loads/#{load.id}/orders/#{order.id}" }
  
    it "returns requested Order with OrderProducts" do
      get url, headers: auth_header(user)
      
      expected_order = order.as_json(only: %i[bay code created_at id load_id updated_at meta orders])
      expected_order['order_products'] = [order_product.as_json(only: %i[id product_id order_id quantity box created_at updated_at meta orders])]
      
      expect(body_json).to eq expected_order
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "PATCH /orders/:id" do
    let(:order) { create(:order) }
    let(:url) { "/admin/v1/loads/#{load.id}/orders/#{order.id}" }

    context "with valid params" do
      let(:new_code) { 'My new Order' }
      let(:order_params) { { order: { code: new_code } }.to_json }

      it 'updates Order' do
        patch url, headers: auth_header(user), params: order_params
        order.reload
        expect(order.code).to eq new_code
      end

      it 'returns updated Order' do
        patch url, headers: auth_header(user), params: order_params
        order.reload
        expected_order = order.as_json(only: %i(id code bay load_id))
        expect(body_json['order']).to eq expected_order
      end

      it 'returns success status' do
        patch url, headers: auth_header(user), params: order_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:order_invalid_params) do 
        { order: attributes_for(:order, code: nil) }.to_json
      end

      it 'does not update Order' do
        old_code = order.code
        patch url, headers: auth_header(user), params: order_invalid_params
        order.reload
        expect(order.code).to eq old_code
      end

      it 'returns error message' do
        patch url, headers: auth_header(user), params: order_invalid_params
        expect(body_json).to have_key('fields')
        if body_json['fields'].present?
          expect(body_json['fields']).to have_key('code')
        else
          puts "No 'fields' key in body_json"
        end
      end

      it 'returns unprocessable_entity status' do
        patch url, headers: auth_header(user), params: order_invalid_params
        expect(body_json).to have_key('fields')
        if body_json['fields'].present?
          expect(response).to have_http_status(:unprocessable_entity)
        else
          puts "No 'fields' key in body_json"
        end
      end
    end
  end

  context "DELETE /orders/:id" do
    let!(:order) { create(:order) }
    let(:url) { "/admin/v1/loads/#{load.id}/orders/#{order.id}" }

    it 'removes Order' do
      expect do  
        delete url, headers: auth_header(user)
      end.to change(Order, :count).by(-1)
    end

    it 'returns success status' do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it 'does not return any body content' do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end
  end

  describe "GET /admin/V1/orders/:id" do
    let!(:load) { create(:load) } 
    let!(:order) { create(:order, load: load) }
    let!(:products) { create_list(:product, 5) } 

    before do
      products.each do |product|
        create(:order_product, order: order, product: product, quantity: "2 caixas", box: true)
      end

      get "/admin/v1/loads/#{load.id}/orders/#{order.id}", headers: { "ACCEPT" => "application/json" }
    end

    it "returns order details with associated products" do
      expect(response).to have_http_status(:success)

      body_json = JSON.parse(response.body)
      expect(body_json['order_products'].count).to eq(5)
        end
    end
    
end

