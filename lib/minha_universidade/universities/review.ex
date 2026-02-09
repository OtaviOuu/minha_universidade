defmodule MinhaUniversidade.Universities.Review do
  use Ash.Resource,
    otp_app: :minha_universidade,
    domain: MinhaUniversidade.Universities,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "reviews"
    repo MinhaUniversidade.Repo
  end

  actions do
    defaults [:read, :destroy, :update]

    create :create do
      accept [:rating, :teacher_discipline_id]

      change relate_actor(:user, allow_nil?: false)
    end
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
    belongs_to :user, MinhaUniversidade.Accounts.User do
      source_attribute :user_id
      destination_attribute :id
    end

    belongs_to :teacher_discipline, MinhaUniversidade.Universities.TeacherDiscipline do
      source_attribute :teacher_discipline_id
      destination_attribute :id
      allow_nil? false
    end
  end
end
