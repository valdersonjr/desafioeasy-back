
require 'rails_helper'

RSpec.describe "Admin V1 Orders without authentication", type: :request do

  let!(:load) { create(:load) }
  let!(:order) { create(:order) }
  let!(:order) { create(:order, load: load) }

  context "GET /orders" do
    let(:url) { "/admin/v1/loads/#{load.id}/orders" }

    let!(:orders) { create(:order) }

    before(:each) { get url }
    
    include_examples "unauthenticated access"
  end

  context "POST /orders" do
    let(:url) { "/admin/v1/loads/#{load.id}/orders" }
    
    before(:each) { post url }
    
    include_examples "unauthenticated access"
  end

  context "GET /orders/:id" do
    let(:order) { create(:order) }
    let(:url) { "/admin/v1/loads/#{load.id}/orders/#{order.id}" }

    before(:each) { get url }

    include_examples "unauthenticated access"
  end

  context "PATCH /orders/:id" do
    let(:order) { create(:order) }
    let(:url) { "/admin/v1/loads/#{load.id}/orders/#{order.id}" }

    before(:each) { patch url }
    
    include_examples "unauthenticated access"
  end

  context "DELETE /orders/:id" do
    let!(:order) { create(:order) }
    let(:url) { "/admin/v1/loads/#{load.id}/orders/#{order.id}" }

    before(:each) { delete url }
    
    include_examples "unauthenticated access"
  end
end
