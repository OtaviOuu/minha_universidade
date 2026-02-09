defmodule MinhaUniversidade.Universities.University do
  use Ash.Resource,
    otp_app: :minha_universidade,
    domain: MinhaUniversidade.Universities,
    data_layer: AshPostgres.DataLayer

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
    end

    attribute :logo_url, :string do
      description "The URL of the university's logo"
      allow_nil? false
    end

    attribute :acronym, :string do
      description "The acronym of the university"
    end

    timestamps()
  end
end
