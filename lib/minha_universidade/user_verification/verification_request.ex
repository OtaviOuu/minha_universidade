defmodule MinhaUniversidade.UserVerification.VerificationRequest do
  use Ash.Resource,
    otp_app: :minha_universidade,
    domain: MinhaUniversidade.UserVerification,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "verification_requests"
    repo MinhaUniversidade.Repo
  end

  actions do
    defaults [:read, :destroy, :create, :update]
    default_accept [:comment, :document, :status, :user_id]
  end

  policies do
    policy always() do
      authorize_if actor_attribute_equals(:role, :admin)
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :comment, :string do
      allow_nil? true
    end

    attribute :document, :string do
      allow_nil? false
    end

    attribute :status, :atom do
      allow_nil? false
      default :pending
      constraints one_of: [:aproved, :rejected, :pending]
    end

    timestamps()
  end

  relationships do
    belongs_to :user, MinhaUniversidade.Accounts.User do
      allow_nil? false
    end
  end
end
