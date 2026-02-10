defmodule MinhaUniversidade.Universities.TeacherDiscipline do
  use Ash.Resource,
    otp_app: :minha_universidade,
    domain: MinhaUniversidade.Universities,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "teacher_disciplines"
    repo MinhaUniversidade.Repo
  end

  actions do
    defaults [:create, :destroy, :update]
    default_accept [:teacher_id, :discipline_id]

    read :read do
      primary? true
    end

    read :read_by_university_acronym do
      argument :university_acronym, :string do
        allow_nil? false
      end

      prepare build(load: [:teacher, discipline: [faculty: [:university]]])
      filter expr(discipline.faculty.university.acronym == ^arg(:university_acronym))
    end
  end

  preparations do
    prepare build(load: [:slug])
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

  # carlos-almeida-mat101-usp-icmc
  calculations do
    calculate :slug,
              :string,
              expr(
                fragment(
                  "lower(replace(? || '-' || ? || '-' || ? || '-' || ?, ' ', '-'))",
                  teacher.name,
                  discipline.code,
                  discipline.faculty.acronym,
                  discipline.faculty.university.acronym
                )
              )
  end
end
