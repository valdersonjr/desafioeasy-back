require 'rails_helper'

RSpec.describe "Admin V1 Loads without authentication", type: :request do
  
  context "GET /loads" do
    let(:url) { "/admin/v1/loads" }
    let!(:loads) { create_list(:load, 5) }

    before(:each) { get url }
    
    include_examples "unauthenticated access"
  end

  context "POST /loads" do
    let(:url) { "/admin/v1/loads" }
    
    before(:each) { post url }
    
    include_examples "unauthenticated access"
  end

  context "GET /loads/:id" do
    let(:load) { create(:load) }
    let(:url) { "/admin/v1/loads/#{load.id}" }

    before(:each) { get url }

    include_examples "unauthenticated access"
  end

  context "PATCH /loads/:id" do
    let(:load) { create(:load) }
    let(:url) { "/admin/v1/loads/#{load.id}" }

    before(:each) { patch url }
    
    include_examples "unauthenticated access"
  end

  context "DELETE /loads/:id" do
    let!(:load) { create(:load) }
    let(:url) { "/admin/v1/loads/#{load.id}" }

    before(:each) { delete url }
    
    include_examples "unauthenticated access"
  end
end
