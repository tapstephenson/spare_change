module UserConcerns
  extend ActiveSupport::Concern

  included do
    def find_user
      @user = User.find(params[:id])
    end
    def all_users
      @users = User.all
    end
    def authorize_user
      authorize @user
    end
  end
end