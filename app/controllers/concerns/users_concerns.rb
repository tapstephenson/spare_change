module UsersConcerns
  extend ActiveSupport::Concern

  included do
    def find_user
      User.find(params[:id])
    end
    def all_users
      User.all
    end
    def authorize_user
      authorize find_user
    end
  end
end