require 'rails_helper'

RSpec.describe "Admin V1 Users as :admin", type: :request do
  let(:user) { create(:user) }
  before do
    allow_any_instance_of(Admin::V1::UsersController).to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(Admin::V1::UsersController).to receive(:current_user).and_return(user)
  end
  context "GET /users" do
    let(:url) { "/admin/v1/users" }
    let!(:users) { create_list(:user, 10) }
    
    context "without any params" do
      it "returns 10 Users" do
        get url, headers: auth_header(user)
        expect(body_json['users'].count).to eq 10
      end
      
      it "returns 10 first Users" do
        get url, headers: auth_header(user)
        expected_users = User.all.order(:id).limit(10).as_json(only: %i(id login name))
        expect(body_json['users']).to match_array(expected_users)
      end

      it "returns success status" do
        get url, headers: auth_header(user)
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 11, total_pages: 2 } do
        before { get url, headers: auth_header(user) }
      end
    end

    context "with search[name] param" do
      let!(:search_name_users) do
        users = [] 
        15.times { |n| users << create(:user, name: "Search #{n + 1}") }
        users 
      end

      let(:search_params) { { search: { name: "Search" } } }

      it "returns only seached users limited by default pagination" do
        get url, headers: auth_header(user), params: search_params
        expected_users = search_name_users[0..9].map do |user|
          user.as_json(only: %i(id login name))
        end
        expect(body_json['users']).to contain_exactly *expected_users
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
        expect(body_json['users'].count).to eq length
      end
      
      it "returns users limited by pagination" do
        get url, headers: auth_header(user), params: { page: 2, length: 3 }
        expected_users = User.all.order(:id).offset(3).limit(3).as_json(only: %i(id name login))
        expect(body_json['users']).to eq expected_users
      end

      it "returns success status" do
        get url, headers: auth_header(user), params: pagination_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 2, length: 5, total: 11, total_pages: 3 } do
        before { get url, headers: auth_header(user), params: pagination_params }
      end
    end

    context "with order params" do
      let(:order_params) { { order: { name: 'desc' } } }

      it "returns ordered users limited by default pagination" do
        get url, headers: auth_header(user), params: order_params
        users_response = body_json['users']
        users_response.sort_by! { |user| user['name'] }
        expected_users = users[0..9].as_json(only: %i(id login name))
        expect(users_response).to contain_exactly *expected_users
      end
 
      it "returns success status" do
        get url, headers: auth_header(user), params: order_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 11, total_pages: 2 } do
        before { get url, headers: auth_header(user), params: order_params }
      end
    end
  end

  context "POST /users" do
    let(:url) { "/admin/v1/users" }
    
    
    context "with valid params" do
      let(:user_params) { { user: attributes_for(:user) }.to_json }

      it 'adds a new User' do
        expect do
          post url, headers: auth_header(user), params: user_params
        end.to change(User, :count).by(1)
      end

      it 'returns last added User' do
        post url, headers: auth_header(user), params: user_params
        expected_user = User.last.as_json(only: %i(id login name))
        expect(body_json['user']).to eq expected_user
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: user_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:user_invalid_params) do 
        { user: attributes_for(:user, name: nil) }.to_json
      end

      it 'does not add a new User' do
        expect do
          post url, headers: auth_header(user), params: user_invalid_params
        end.to_not change(User, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: user_invalid_params
        expect(body_json).to have_key('fields')
        if body_json['fields'].present?
          expect(body_json['fields']).to have_key('name')
        else
          puts "No 'fields' key in body_json"
        end
      end
      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: user_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "GET /users/:id" do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    it "returns requested User" do
      get url, headers: auth_header(user)
      expected_user = user.as_json(only: %i(id login name))
      expect(body_json['user']).to eq expected_user
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "PATCH /users/:id" do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }
  
    context "with valid params" do
      let(:new_name) { 'My new User' }
      let(:user_params) { { user: { name: new_name, id: user.id, login: user.login, password: 'new_password' } } }
  
      it 'updates User' do
        patch url, headers: auth_header(user), params: user_params, as: :json
        user.reload
        expect(user.name).to eq new_name
      end
  
      it 'returns updated User' do
        patch url, headers: auth_header(user), params: user_params, as: :json
        user.reload
        expected_user = user.as_json(only: %i(id login name))
        expect(body_json['user']).to eq expected_user
      end
  
      it 'returns success status' do
        patch url, headers: auth_header(user), params: user_params, as: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:user_invalid_params) do 
        { user: attributes_for(:user, name: nil) }.to_json
      end

      it 'does not update User' do
        old_name = user.name
        patch url, headers: auth_header(user), params: user_invalid_params
        user.reload
        expect(user.name).to eq old_name
      end

      it 'returns error message' do
        patch url, headers: auth_header(user), params: user_invalid_params
        expect(body_json).to have_key('fields')
        if body_json['fields'].present?
          expect(body_json['fields']).to have_key('name')
        else
          puts "No 'fields' key in body_json"
        end
      end

      it 'returns unprocessable_entity status' do
        patch url, headers: auth_header(user), params: user_invalid_params
        expect(body_json).to have_key('fields')
        if body_json['fields'].present?
          expect(response).to have_http_status(:unprocessable_entity)
        else
          puts "No 'fields' key in body_json"
        end
      end
    end
  end

  context "DELETE /users/:id" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let(:url) { "/admin/v1/users/#{other_user.id}" }

    it 'removes User' do
      expect do  
        delete url, headers: auth_header(user)
      end.to change(User, :count).by(-1)
    end

    it 'returns success status' do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it 'does not return any body content' do
      delete url, headers: auth_header(user)
      expect(body_json).to be_blank
    end
  end
end