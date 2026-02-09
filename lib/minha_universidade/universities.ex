defmodule MinhaUniversidade.Universities do
  use Ash.Domain,
    otp_app: :minha_universidade,
    extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource MinhaUniversidade.Universities.University
    resource MinhaUniversidade.Universities.Teacher
    resource MinhaUniversidade.Universities.Discipline
    resource MinhaUniversidade.Universities.Review

    resource MinhaUniversidade.Universities.TeacherDiscipline do
      define :list_teacher_discipline_reviews, action: :read
    end
  end
end
