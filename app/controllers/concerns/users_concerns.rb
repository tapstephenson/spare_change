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
    def profile_complete
      current_user.bank && 
      current_user.plaid_access_token &&
      current_user.stripe_customer_id && 
      current_user.stripe_subscription_id
    end

    def plaid_complete
      current_user.bank &&
      current_user.plaid_access_token
    end

    def stripe_complete
      current_user.stripe_customer_id &&
      current_user.stripe_subscription_id
    end
  end
end