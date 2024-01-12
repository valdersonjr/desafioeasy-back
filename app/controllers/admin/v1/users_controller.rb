module Admin::V1
    class UsersController < ApiController
      before_action :authenticate_user!
      before_action :load_user, only: [:show, :update, :destroy]
      def index
        permitted = params.permit({ search: :name }, { order: {} }, :page, :length)
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
      rescue ActiveRecord::RecordNotDestroyed => e
        render_error(fields: @user.errors.messages.merge(base: [e.message]))
      end
  
      private
  
      def load_user
        @user = User.find(params[:id])
      end
  
      def searchable_params
        params.permit({ search: :name }, { order: {} }, :page, :length)
      end
  
      def user_params
        return {} unless params.has_key?(:user)
        params.require(:user).permit(:id, :login, :name, :email, :password, :password_confirmation)
      end
  
      def save_user!
        @user.save!
        render :show
      rescue StandardError => e
        render_error(fields: @user.errors.messages.merge(base: [e.message]))
      end
    end
  end
  