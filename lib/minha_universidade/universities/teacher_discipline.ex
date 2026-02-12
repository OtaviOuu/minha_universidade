defmodule MinhaUniversidade.Universities.TeacherDiscipline do
  use Ash.Resource,
    otp_app: :minha_universidade,
    domain: MinhaUniversidade.Universities,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  json_api do
    type "teacher_discipline"

    includes [:teacher, discipline: [faculty: [:university]], reviews: []]
  end

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

    read :search do
      argument :acronym, :string do
        allow_nil? false
      end

      argument :query, :string do
        allow_nil? true
      end

      prepare build(load: [:teacher, discipline: [faculty: [:university]]])

      filter expr(discipline.faculty.university.acronym == ^arg(:acronym))

      filter expr(
               ilike(teacher.name, "%" <> ^arg(:query) <> "%") ||
                 ilike(discipline.code, "%" <> ^arg(:query) <> "%") ||
                 ilike(discipline.faculty.acronym, "%" <> ^arg(:query) <> "%") ||
                 ilike(discipline.faculty.university.acronym, "%" <> ^arg(:query) <> "%") ||
                 ilike(discipline.name, "%" <> ^arg(:query) <> "%")
             )
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
      public? true
    end

    belongs_to :discipline, MinhaUniversidade.Universities.Discipline do
      source_attribute :discipline_id
      destination_attribute :id
      public? true
    end

    has_many :reviews, MinhaUniversidade.Universities.Review do
      source_attribute :id
      destination_attribute :teacher_discipline_id
      public? true
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
