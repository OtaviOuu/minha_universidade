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
          <li class="p-4 pb-2 text-xs opacity-60 tracking-wide">
            <label class="input">
              <.icon name="hero-magnifying-glass" class="size-5 opacity-60" />
              <form phx-change="search_disciplina_professor">
                <input type="search" name="query" placeholder="pesquisar" />
              </form>
            </label>
          </li>
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
    <.link navigate={
      ~p"/universidades/#{@disciplina_professor.discipline.faculty.university.acronym}/disciplinas-professores/#{@disciplina_professor.slug}"
    }>
      <li class="list-row cursor-pointer">
        
    <!-- texto ocupa o espaço -->
        <div class="flex-1 min-w-0">
          <div>
            {@disciplina_professor.discipline.code} - {@disciplina_professor.discipline.name}
          </div>
          <div class="text-xs uppercase font-semibold opacity-60 truncate">
            {@disciplina_professor.teacher.name} - {@disciplina_professor.discipline.faculty.acronym}
          </div>
        </div>
        
    <!-- logo totalmente à direita -->
        <div class="size-10 rounded-box shrink-0 ml-auto">
          <img
            class="w-full h-full"
            src={@disciplina_professor.discipline.faculty.logo_url}
          />
        </div>
      </li>
    </.link>
    """
  end

  defp assign_disciplinas_professores(socket) do
    university_acronym = socket.assigns.university_acronym

    case MinhaUniversidade.Universities.list_teacher_discipline_by_university_acronym(
           university_acronym
         ) do
      {:ok, disciplinas_professores} ->
        assign(socket, :disciplinas_professores, disciplinas_professores)

      {:error, reason} ->
        socket
        |> put_flash(:error, "Failed to load teacher disciplines: #{reason}")
        |> push_navigate(to: ~p"/universidades/#{university_acronym}/disciplinas-professores")
    end
  end

  def handle_event("search_disciplina_professor", %{"query" => query}, socket) do
    university_acronym = socket.assigns.university_acronym

    is_empty_query? = String.trim(query) == ""

    with false <- is_empty_query? do
      case MinhaUniversidade.Universities.search_teacher_discipline(
             university_acronym,
             query
           ) do
        {:ok, teacher_disciplines} ->
          socket =
            socket
            |> assign(:disciplinas_professores, teacher_disciplines)

          {:noreply, socket}

        {:error, reason} ->
          socket =
            socket
            |> put_flash(:error, "Failed to search teacher disciplines")

          {:noreply, socket}
      end
    else
      true ->
        {:noreply, assign_disciplinas_professores(socket)}
    end
  end
end
