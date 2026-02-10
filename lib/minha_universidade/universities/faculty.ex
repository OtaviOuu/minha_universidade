defmodule MinhaUniversidade.Universities.Faculty do
  use Ash.Resource,
    otp_app: :minha_universidade,
    domain: MinhaUniversidade.Universities,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "faculties"
    repo MinhaUniversidade.Repo
  end

  actions do
    defaults [:read, :destroy, :create, :update]
    default_accept [:name, :acronym, :university_id, :logo_url]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      description "The name of the faculty"
      allow_nil? false
    end

    attribute :acronym, :string do
      description "The acronym of the faculty"
      allow_nil? false
    end

    attribute :logo_url, :string do
      description "The URL of the faculty/departament logo"
      allow_nil? true
    end

    timestamps()
  end

  relationships do
    belongs_to :university, MinhaUniversidade.Universities.University do
      source_attribute :university_id
      destination_attribute :id
    end
  end
end
