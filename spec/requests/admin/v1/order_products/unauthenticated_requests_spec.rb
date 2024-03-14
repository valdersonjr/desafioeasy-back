require 'rails_helper'

RSpec.describe "Admin V1 OrderProducts without authentication", type: :request do
    let!(:order) { create(:order) }
    let!(:product) { create(:product) }
    let!(:order_product) { create(:order_product, order: order, product: product) }
  context "GET /order_products" do
    let(:url) { "/admin/v1/orders/#{order.id}/order_products" }

    let!(:order_products) { create(:order_product) }

    before(:each) { get url }
    
    include_examples "unauthenticated access"
  end

  context "POST /order_products" do
    let(:url) { "/admin/v1/orders/#{order.id}/order_products" }
    
    before(:each) { post url }
    
    include_examples "unauthenticated access"
  end

  context "GET /order_products/:id" do
    let!(:order_products) { create(:order_product) }
    let(:url) { "/admin/v1/orders/#{order.id}/order_products/#{order_products.id}" }

    before(:each) { get url }

    include_examples "unauthenticated access"
  end

  context "PATCH /order_products/:id" do
    let!(:order_products) { create_list(:order_product, 5) }
    let(:url) { "/admin/v1/orders/#{order.id}/order_products/#{order_product.id}" }

    before(:each) { patch url }
    
    include_examples "unauthenticated access"
  end

  context "DELETE /order_products/:id" do
    let!(:order_products) { create_list(:order_product, 5) }
    let(:url) { "/admin/v1/orders/#{order.id}/order_products/#{order_product.id}" }

    before(:each) { delete url }
    
    include_examples "unauthenticated access"
  end
end
