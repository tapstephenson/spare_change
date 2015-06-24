module UserConcerns
  extend ActiveSupport::Concern

  included do
    def find_user
      User.find(params[:id])
    end
    def all_users
      User.all
    end
    def all_charities
      @charities = Charity.all
    end
    def authorize_user
      authorize current_user
    end
    def profile_complete
      plaid_complete &&
      stripe_complete &&
      charity_complete
    end

    def plaid_complete
      current_user.bank &&
      current_user.plaid_access_token
    end

    def charity_complete
      current_user.charity_id
    end

    def stripe_complete
      current_user.stripe_customer_id &&
      current_user.stripe_subscription_id
    end
  end
end