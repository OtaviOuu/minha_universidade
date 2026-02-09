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
      define :list_teacher_discipline, action: :read
      define :get_teacher_discipline_by_teacher_id, action: :read, get_by: [:teacher_id]
      define :get_teacher_discipline_by_discipline_id, action: :read, get_by: [:discipline_id]
    end

    resource MinhaUniversidade.Universities.Faculty
  end
end
