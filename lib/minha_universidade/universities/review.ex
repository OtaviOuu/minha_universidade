defmodule MinhaUniversidade.Universities.Review do
  use Ash.Resource,
    otp_app: :minha_universidade,
    domain: MinhaUniversidade.Universities,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "reviews"
    repo MinhaUniversidade.Repo
  end

  actions do
    defaults [:read, :destroy, :update]

    default_accept [
      :teacher_discipline_id,
      :user_id,
      :didactics_rate,
      :exams_rate,
      :exams_comments,
      :enforces_attendance?,
      :enforces_attendance_comments,
      :geral_rating,
      :geral_comments,
      :recommends?
    ]

    read :search do
      argument :teacher_discipline_id, :uuid do
        allow_nil? false
      end

      argument :query, :string do
        allow_nil? false
      end

      filter expr(teacher_discipline_id == ^arg(:teacher_discipline_id))

      filter expr(
               ilike(exams_comments, "%" <> ^arg(:query) <> "%") or
                 ilike(enforces_attendance_comments, "%" <> ^arg(:query) <> "%") or
                 ilike(geral_comments, "%" <> ^arg(:query) <> "%")
             )
    end

    create :create do
      accept [
        :teacher_discipline_id,
        :user_id,
        :didactics_rate,
        :exams_rate,
        :exams_comments,
        :enforces_attendance?,
        :enforces_attendance_comments,
        :geral_rating,
        :geral_comments,
        :recommends?
      ]

      change relate_actor(:user, allow_nil?: false)
    end

    read :read_teacher_discipline do
      argument :teacher_discipline_id, :uuid do
        allow_nil? false
      end

      filter expr(teacher_discipline_id == ^arg(:teacher_discipline_id))
    end
  end

  policies do
    policy action_type(:create) do
      authorize_if actor_attribute_equals(:admin, true)
      authorize_if actor_attribute_equals(:verified?, true)
    end

    policy action_type(:read) do
      authorize_if always()
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :didactics_rate, :integer do
      allow_nil? false
      public? true
    end

    attribute :exams_rate, :integer do
      allow_nil? false
      public? true
    end

    attribute :exams_comments, :string do
      allow_nil? false
      public? true
    end

    attribute :enforces_attendance?, :boolean do
      allow_nil? false
      public? true
    end

    attribute :enforces_attendance_comments, :string do
      allow_nil? false
    end

    attribute :geral_rating, :integer do
      description "The rating of the review"
      allow_nil? false
    end

    attribute :geral_comments, :string do
      allow_nil? false
    end

    attribute :recommends?, :boolean do
      description "Whether the reviewer recommends the teacher or not"
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

  identities do
    identity :unique_review_per_user, [:user_id, :teacher_discipline_id],
      field_names: [:user_id],
      message: "You have already reviewed this teacher and discipline"
  end
end
