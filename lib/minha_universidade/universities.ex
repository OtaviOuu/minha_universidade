defmodule MinhaUniversidade.Universities do
  use Ash.Domain,
    otp_app: :minha_universidade

  resources do
    resource MinhaUniversidade.Universities.University
    resource MinhaUniversidade.Universities.Teacher
    resource MinhaUniversidade.Universities.Discipline
    resource MinhaUniversidade.Universities.Review
    resource MinhaUniversidade.Universities.TeacherDiscipline
  end
end
