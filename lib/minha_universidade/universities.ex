defmodule MinhaUniversidade.Universities do
  use Ash.Domain,
    otp_app: :minha_universidade,
    extensions: [AshJsonApi.Domain, AshAdmin.Domain, AshPhoenix]

  json_api do
    routes do
      base_route "/universities", MinhaUniversidade.Universities.University do
        index :read
      end

      base_route "/teacher-disciplines", MinhaUniversidade.Universities.TeacherDiscipline do
        index :read_by_university_acronym
      end
    end
  end

  admin do
    show? true
  end

  resources do
    resource MinhaUniversidade.Universities.University do
      define :list_universities, action: :read
      define :get_university_by_acronym, action: :read, get_by: [:acronym]
    end

    resource MinhaUniversidade.Universities.Teacher
    resource MinhaUniversidade.Universities.Discipline

    resource MinhaUniversidade.Universities.Review do
      define :create_review, action: :create

      define :search_reviews,
        action: :search,
        args: [:teacher_discipline_id, :query]

      define :list_teacher_discipline_reviews,
        action: :read_teacher_discipline,
        args: [:teacher_discipline_id]
    end

    resource MinhaUniversidade.Universities.TeacherDiscipline do
      define :list_teacher_discipline, action: :read
      define :search_teacher_discipline, action: :search, args: [:acronym, :query]

      define :list_teacher_discipline_by_university_acronym,
        action: :read_by_university_acronym,
        args: [:university_acronym]

      define :get_teacher_discipline, action: :read, get_by: [:id]
      define :get_teacher_discipline_by_slug, action: :read, get_by: [:slug]
    end

    resource MinhaUniversidade.Universities.Faculty
  end
end
