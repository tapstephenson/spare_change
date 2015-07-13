module UserConcerns
  extend ActiveSupport::Concern

  included do
    def find_user
      User.find(params[:id])
    end
    def all_users
      @users = User.all
    end
    def all_charities
      @charities = Charity.all
    end
    def authorize_user
      authorize current_user
    end
  end
end