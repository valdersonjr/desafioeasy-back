
require 'rails_helper'

RSpec.describe "Admin V1 Orders without authentication", type: :request do
  
  context "GET /orders" do
    let(:url) { "/admin/v1/orders" }
    let!(:orders) { create_list(:order, 5) }

    before(:each) { get url }
    
    include_examples "unauthenticated access"
  end

  context "POST /orders" do
    let(:url) { "/admin/v1/orders" }
    
    before(:each) { post url }
    
    include_examples "unauthenticated access"
  end

  context "GET /orders/:id" do
    let(:order) { create(:order) }
    let(:url) { "/admin/v1/orders/#{order.id}" }

    before(:each) { get url }

    include_examples "unauthenticated access"
  end

  context "PATCH /orders/:id" do
    let(:order) { create(:order) }
    let(:url) { "/admin/v1/orders/#{order.id}" }

    before(:each) { patch url }
    
    include_examples "unauthenticated access"
  end

  context "DELETE /orders/:id" do
    let!(:order) { create(:order) }
    let(:url) { "/admin/v1/orders/#{order.id}" }

    before(:each) { delete url }
    
    include_examples "unauthenticated access"
  end
end
