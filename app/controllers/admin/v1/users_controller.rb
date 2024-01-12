module Admin::V1
    class UsersController < ApiController
      
      before_action :load_user, only: [:show, :update, :destroy]
      before_action :build_user, only: [:create, :update]
      before_action :authenticate_user!
      def index
        @loading_service = Admin::ModelLoadingService.new(User.all, searchable_params)
        @loading_service.call
      end
  
      def create
        @user = User.new
        @user.attributes = user_params
        save_user!
      end
  
      def show; end
  
      def update
        @user.attributes = user_params
        save_user!
      end
  
      def destroy
        @user.destroy!
      rescue
        render_error(fields: @user.errors.messages)
      end
  
      private
  
      def build_user
        @user = params[:id] ? User.find(params[:id]) : User.new
        @user.attributes = user_params
      end
  
      def load_user
        @user = User.find(params[:id])
      end
  
      def searchable_params
        params.permit({ search: :login }, { order: {} }, :page, :length)
      end
  
      def user_params
        return {} unless params.has_key?(:user)
        params.require(:user).permit(:id, :name, :login)
      end
  
      def save_user!
        @user.save!
        render :show
      rescue StandardError => e
        render_error(fields: @user.errors.messages.merge(base: [e.message]))
      end
    end
  end
  