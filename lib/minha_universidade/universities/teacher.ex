defmodule MinhaUniversidade.Universities.Teacher do
  use Ash.Resource,
    otp_app: :minha_universidade,
    domain: MinhaUniversidade.Universities,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "teachers"
    repo MinhaUniversidade.Repo
  end

  actions do
    defaults [:read, :destroy, :create, :update]
    default_accept [:name, :email]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      description "The name of the teacher"
      allow_nil? true
      public? true
    end

    attribute :email, :string do
      description "The email of the teacher"
      allow_nil? true
      public? true
    end

    timestamps()
  end

  relationships do
    many_to_many :disciplines, MinhaUniversidade.Universities.Discipline do
      through MinhaUniversidade.Universities.TeacherDiscipline
      source_attribute_on_join_resource :teacher_id
      destination_attribute_on_join_resource :discipline_id
    end
  end
end
