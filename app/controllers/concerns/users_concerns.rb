module UsersConcerns
  extend ActiveSupport::Concern

  included do
    def find_user
      User.find(params[:id])
    end
<<<<<<< Updated upstream:app/controllers/concerns/users.rb
=======
    def all_users
      User.all
    end
>>>>>>> Stashed changes:app/controllers/concerns/users_concerns.rb
    def authorize_user
      authorize find_user
    end
  end
end