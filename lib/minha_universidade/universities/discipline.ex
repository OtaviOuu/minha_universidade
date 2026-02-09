defmodule MinhaUniversidade.Universities.Discipline do
  use Ash.Resource,
    otp_app: :minha_universidade,
    domain: MinhaUniversidade.Universities,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "disciplines"
    repo MinhaUniversidade.Repo
  end

  actions do
    defaults [:read, :destroy, :create, :update]
    default_accept [:name, :code]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      description "The name of the discipline"
      allow_nil? true
    end

    attribute :code, :string do
      description "The code of the discipline"
      allow_nil? true
    end

    timestamps()
  end

  relationships do
    many_to_many :teachers, MinhaUniversidade.Universities.Teacher do
      through MinhaUniversidade.Universities.TeacherDiscipline
      source_attribute_on_join_resource :discipline_id
      destination_attribute_on_join_resource :teacher_id
    end
  end
end
