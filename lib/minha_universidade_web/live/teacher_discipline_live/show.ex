defmodule MinhaUniversidadeWeb.TeacherDisciplineLive.Show do
  use MinhaUniversidadeWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <h1>Teacher Discipline Show</h1>
    </Layouts.app>
    """
  end
end
