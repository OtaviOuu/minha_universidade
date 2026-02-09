defmodule MinhaUniversidadeWeb.TeacherDisciplineLive.Index do
  use MinhaUniversidadeWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <h1>Teacher Discipline Index</h1>
    </Layouts.app>
    """
  end
end
