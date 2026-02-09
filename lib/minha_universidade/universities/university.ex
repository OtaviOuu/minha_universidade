defmodule MinhaUniversidade.Universities.University do
  use Ash.Resource,
    otp_app: :minha_universidade,
    domain: MinhaUniversidade.Universities,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "universities"
    repo MinhaUniversidade.Repo
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      description "The name of the university"
    end

    attribute :acronym, :string do
      description "The acronym of the university"
    end

    timestamps()
  end
end
