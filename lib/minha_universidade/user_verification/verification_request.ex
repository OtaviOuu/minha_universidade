defmodule MinhaUniversidade.UserVerification.VerificationRequest do
  require Ash.Resource.Change.Builtins

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
    default_accept [:comment, :document, :status, :user_id, :applied_university_id]

    update :approve_request do
      require_atomic? false
      accept [:status]

      change set_attribute(:status, :approved)

      change MinhaUniversidade.UserVerification.Changes.AttachUniversityToUser
    end
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
      constraints one_of: [:approved, :rejected, :pending]
    end

    timestamps()
  end

  relationships do
    belongs_to :user, MinhaUniversidade.Accounts.User do
      allow_nil? false
    end

    belongs_to :applied_university, MinhaUniversidade.Universities.University do
      allow_nil? false
      source_attribute :applied_university_id
      destination_attribute :id
    end
  end
end
