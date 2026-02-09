defmodule MinhaUniversidadeWeb.TeacherDisciplineLive.Show do
  use MinhaUniversidadeWeb, :live_view

  def mount(%{"slug" => slug}, _session, socket) do
    socket =
      socket
      |> assign_teacher_discipline(slug)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>Unidade de avaliação</.header>
    </Layouts.app>
    """
  end

  def assign_teacher_discipline(socket, slug) do
    case MinhaUniversidade.Universities.get_teacher_discipline_by_slug(slug,
           load: [:teacher, :discipline]
         ) do
      {:ok, teacher_discipline} ->
        assign(socket, :teacher_discipline, teacher_discipline)

      {:error, reason} ->
        socket
        |> put_flash(:error, "Failed to load teacher discipline")
        |> push_navigate(to: ~p"/disciplinas-professores")
    end
  end
end
