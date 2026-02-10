defmodule MinhaUniversidadeWeb.TeacherDisciplineLive.Index do
  use MinhaUniversidadeWeb, :live_view

  def mount(%{"university_acronym" => university_acronym}, _session, socket) do
    socket =
      socket
      |> assign(:university_acronym, university_acronym)
      |> assign_disciplinas_professores()

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Disciplinas
        <:subtitle>
          Explore as disciplinas oferecidas por nossos professores e descubra as melhores
        </:subtitle>
      </.header>
      <section class="container mx-auto p-4">
        <ul class="list bg-base-100 rounded-box shadow-md">
          <li class="p-4 pb-2 text-xs opacity-60 tracking-wide">Most played songs this week</li>
          <.disciplina_professor_row
            :for={disciplina_professor <- @disciplinas_professores}
            disciplina_professor={disciplina_professor}
          />
        </ul>
      </section>
    </Layouts.app>
    """
  end

  defp disciplina_professor_row(assigns) do
    ~H"""
    <li class="list-row cursor-pointer">
      <.link navigate={
        ~p"/universidades/#{@disciplina_professor.discipline.faculty.university.acronym}/disciplinas-professores/#{@disciplina_professor.slug}"
      }>
        <div></div>
        <div>
          <div>{@disciplina_professor.discipline.code} - {@disciplina_professor.discipline.name}</div>
          <div class="text-xs uppercase font-semibold opacity-60">
            {@disciplina_professor.teacher.name} - {@disciplina_professor.discipline.faculty.acronym}
          </div>
        </div>
        <button class="btn btn-square btn-ghost">
          <svg class="size-[1.2em]" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <g
              stroke-linejoin="round"
              stroke-linecap="round"
              stroke-width="2"
              fill="none"
              stroke="currentColor"
            >
              <path d="M6 3L20 12 6 21 6 3z"></path>
            </g>
          </svg>
        </button>
        <button class="btn btn-square btn-ghost">
          <svg class="size-[1.2em]" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <g
              stroke-linejoin="round"
              stroke-linecap="round"
              stroke-width="2"
              fill="none"
              stroke="currentColor"
            >
              <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z">
              </path>
            </g>
          </svg>
        </button>
      </.link>
    </li>
    """
  end

  defp assign_disciplinas_professores(socket) do
    university_acronym = socket.assigns.university_acronym

    case MinhaUniversidade.Universities.list_teacher_discipline_by_university_acronym(
           university_acronym
         ) do
      {:ok, disciplinas_professores} ->
        dbg(disciplinas_professores)
        assign(socket, :disciplinas_professores, disciplinas_professores)

      {:error, reason} ->
        socket
        |> put_flash(:error, "Failed to load teacher disciplines: #{reason}")
        |> push_navigate(to: ~p"/universidades/#{university_acronym}/disciplinas-professores")
    end
  end
end
