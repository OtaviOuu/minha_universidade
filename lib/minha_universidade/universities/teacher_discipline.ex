defmodule MinhaUniversidade.Universities.TeacherDiscipline do
  use Ash.Resource,
    otp_app: :minha_universidade,
    domain: MinhaUniversidade.Universities,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "teacher_disciplines"
    repo MinhaUniversidade.Repo
  end

  attributes do
    uuid_v7_primary_key :id

    timestamps()
  end

  relationships do
    belongs_to :teacher, MinhaUniversidade.Universities.Teacher do
      source_attribute :teacher_id
      destination_attribute :id
    end

    belongs_to :discipline, MinhaUniversidade.Universities.Discipline do
      source_attribute :discipline_id
      destination_attribute :id
    end

    has_many :reviews, MinhaUniversidade.Universities.Review do
      source_attribute :id
      destination_attribute :teacher_discipline_id
    end
  end
end
