defmodule MinhaUniversidade.Universities.Review do
  use Ash.Resource,
    otp_app: :minha_universidade,
    domain: MinhaUniversidade.Universities,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "reviews"
    repo MinhaUniversidade.Repo
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :rating, :integer do
      description "The rating of the review"
      allow_nil? false
    end

    timestamps()
  end

  relationships do
    belongs_to :teacher_discipline, MinhaUniversidade.Universities.TeacherDiscipline do
      source_attribute :teacher_discipline_id
      destination_attribute :id
    end
  end
end
