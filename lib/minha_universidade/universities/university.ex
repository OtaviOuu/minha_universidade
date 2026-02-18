defmodule MinhaUniversidade.Universities.University do
  use Ash.Resource,
    otp_app: :minha_universidade,
    domain: MinhaUniversidade.Universities,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  json_api do
    type "university"
  end

  postgres do
    table "universities"
    repo MinhaUniversidade.Repo
  end

  actions do
    defaults [:read, :destroy, :create, :update]
    default_accept [:name, :logo_url, :acronym]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      description "The name of the university"
      public? true
    end

    attribute :logo_url, :string do
      description "The URL of the university's logo"
      allow_nil? false
      public? true
    end

    attribute :acronym, :string do
      description "The acronym of the university"
      public? true
    end

    timestamps()
  end

  relationships do
    has_many :faculties, MinhaUniversidade.Universities.Faculty do
      source_attribute :id
      destination_attribute :university_id
    end

    has_many :users, MinhaUniversidade.Accounts.User do
      source_attribute :id
      destination_attribute :university_id
    end
  end
end
