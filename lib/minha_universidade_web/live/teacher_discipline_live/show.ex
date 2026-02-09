defmodule MinhaUniversidadeWeb.TeacherDisciplineLive.Show do
  use MinhaUniversidadeWeb, :live_view

  def mount(%{"slug" => slug}, _session, socket) do
    socket =
      socket
      |> assign(:slug, slug)
      |> assign_teacher_discipline(slug)
      |> assign_reviews()

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Avaliações para:
        <span class="badge badge-secondary">
          {@teacher_discipline.discipline.name} - {@teacher_discipline.discipline.code} - {@teacher_discipline.discipline.faculty.university.acronym}
        </span>
        <:subtitle>
          Veja as avaliações e comentários de outros estudantes para ajudar a escolher as melhores opções para suas jornadas acadêmicas.
        </:subtitle>
        <:actions>
          <.link navigate={~p"/disciplinas-professores/#{@slug}/avaliar"} class="btn btn-primary">
            Avaliar
          </.link>
        </:actions>
      </.header>

      <section class="container mx-auto p-4">
        <.disciplines_teacher_list reviews={@reviews} />
      </section>
    </Layouts.app>
    """
  end

  defp assign_teacher_discipline(socket, slug) do
    case MinhaUniversidade.Universities.get_teacher_discipline_by_slug(slug,
           load: [:teacher, discipline: [faculty: [:university]]]
         ) do
      {:ok, teacher_discipline} ->
        assign(socket, :teacher_discipline, teacher_discipline)

      {:error, reason} ->
        socket
        |> put_flash(:error, "Failed to load teacher discipline: #{reason}")
        |> push_navigate(to: ~p"/disciplinas-professores")
    end
  end

  defp assign_reviews(socket) do
    {:ok, reviews} =
      MinhaUniversidade.Universities.list_teacher_discipline_reviews(
        socket.assigns.teacher_discipline.id
      )

    assign(socket, :reviews, reviews)
  end

  def disciplines_teacher_list(assigns) do
    ~H"""
    <ul class="list bg-base-100 rounded-box shadow-md">
      <li class="p-4 pb-2 text-xs opacity-60 tracking-wide">Most played songs this week</li>
      <.disciplines_teacher_row :for={review <- @reviews} review={review} />
    </ul>
    """
  end

  def disciplines_teacher_row(assigns) do
    ~H"""
    <li class="list-row">
      <div>
        <img
          class="size-10 rounded-box"
          src="https://img.daisyui.com/images/profile/demo/1@94.webp"
        />
      </div>
      <div>
        <div>Dio Lupa</div>
        <div class="text-xs uppercase font-semibold opacity-60">Remaining Reason</div>
      </div>
      <p class="list-col-wrap text-xs">
        {@review.geral_comments}
      </p>
      <button class="btn btn-square btn-ghost">
        <.icon name="hero-hand-thumb-up" class="size-[1.2em]" />
      </button>
      <button class="btn btn-square btn-ghost">
        <.icon name="hero-hand-thumb-down" class="size-[1.2em]" />
      </button>
    </li>
    """
  end
end
