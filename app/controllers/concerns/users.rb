module User_concerns
  extend ActiveSupport::Concern

  included do
    def find_user
      @user = User.find(params[:id])
    end
    def authorize_user
      authorize @user
    end
  end
end