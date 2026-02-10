defmodule MinhaUniversidadeWeb.TeacherDisciplineLive.Show do
  use MinhaUniversidadeWeb, :live_view

  def mount(%{"slug" => slug, "university_acronym" => university_acronym}, _session, socket) do
    socket =
      socket
      |> assign(:slug, slug)
      |> assign(:university_acronym, university_acronym)
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
          <.link
            navigate={
              ~p"/universidades/#{@university_acronym}/disciplinas-professores/#{@slug}/avaliar"
            }
            class="btn btn-primary"
          >
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
        |> push_navigate(
          to: ~p"/universidades/#{socket.assigns.university_acronym}/disciplinas-professores"
        )
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
      <li class="p-4 pb-2 text-xs opacity-60 tracking-wide">
        <label class="input">
          <.icon name="hero-magnifying-glass" class="size-5 opacity-60" />
          <form phx-change="search_reviews">
            <input type="search" name="query" placeholder="pesquisar" />
          </form>
        </label>
      </li>
      <.disciplines_teacher_row
        :for={review <- @reviews}
        review={review}
      />
    </ul>
    """
  end

  def disciplines_teacher_row(assigns) do
    ~H"""
    <li class="list-row flex flex-col gap-2 cursor-pointer hover:bg-base-200 rounded-box p-4">
      <div class="modal cursor-default  " role="dialog" id={"review-#{@review.id}"}>
        <div class="modal-box w-11/12 max-w-5xl">
          <.review_modal_content review={@review} />
          <div class="modal-action"></div>

          <a href="#" class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2 size">x</a>
        </div>
      </div>
      <.link href={"#review-#{@review.id}"}>
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-3">
            <img
              class="size-10 rounded-box"
              src="https://img.daisyui.com/images/profile/demo/1@94.webp"
            />

            <div>
              <div>Dio Lupa</div>

              <div class="flex gap-2 text-xs uppercase font-semibold opacity-60">
                <div class="badge badge-sm badge-primary">
                  Didática: {@review.didactics_rate}
                </div>

                <div class="badge badge-sm badge-primary">
                  Avaliações: {@review.exams_rate}
                </div>
              </div>
            </div>
          </div>

          <div class="badge badge-primary">
            Geral: {@review.geral_rating}
          </div>
        </div>

        <p class="text-xs opacity-80">
          {@review.geral_comments}
        </p>
      </.link>
    </li>
    """
  end

  attr :review, :any, required: true

  def review_modal_content(assigns) do
    ~H"""
    <div class="space-y-6">
      <.header>
        Avaliação
        <:subtitle>
          Avaliação detalhada para ajudar outros estudantes a escolherem melhores opções.
        </:subtitle>
      </.header>
      
    <!-- Geral -->
      <div class="card bg-base-100 shadow">
        <div class="card-body">
          <h3 class="card-title">Comentário Geral</h3>
          <p class="text-base-content/80 whitespace-pre-line">
            {@review.geral_comments || "Nenhum comentário geral."}
          </p>

          <div class="mt-2">
            <div class="badge badge-primary">
              Nota geral: {@review.geral_rating || "-"}
            </div>
          </div>
        </div>
      </div>
      
    <!-- Didática -->
      <div class="card bg-base-100 shadow">
        <div class="card-body">
          <h3 class="card-title">Didática</h3>

          <div class="mt-2">
            <div class="badge badge-secondary">
              Nota: {@review.didactics_rate || "-"}
            </div>
          </div>
        </div>
      </div>
      
    <!-- Provas -->
      <div class="card bg-base-100 shadow">
        <div class="card-body">
          <h3 class="card-title">Provas</h3>
          <p class="text-base-content/80 whitespace-pre-line">
            {@review.exams_comments || "Sem comentários sobre provas."}
          </p>

          <div class="mt-2">
            <div class="badge badge-accent">
              Nota: {@review.exams_rate || "-"}
            </div>
          </div>
        </div>
      </div>
      
    <!-- Presença -->
      <div class="card bg-base-100 shadow">
        <div class="card-body">
          <h3 class="card-title">Presença</h3>

          <p class="text-base-content/80 whitespace-pre-line">
            {@review.enforces_attendance_comments || "Sem comentários sobre presença."}
          </p>

          <div class="mt-2 flex gap-2">
            <div class={[
              "badge",
              if(@review.enforces_attendance?, do: "badge-warning", else: "badge-success")
            ]}>
              {if @review.enforces_attendance?, do: "Cobra presença", else: "Não cobra presença"}
            </div>
          </div>
        </div>
      </div>
      
    <!-- Recomendação -->
      <div class="card bg-base-100 shadow">
        <div class="card-body">
          <h3 class="card-title">Recomendação</h3>

          <div class={[
            "badge text-sm",
            if(@review.recommends?, do: "badge-success", else: "badge-error")
          ]}>
            {if @review.recommends?, do: "Recomenda", else: "Não recomenda"}
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("search_reviews", %{"query" => query}, socket) do
    teacher_discipline_id = socket.assigns.teacher_discipline.id
    is_empty_query? = String.trim(query) == ""

    with false <- is_empty_query? do
      case MinhaUniversidade.Universities.search_reviews(
             teacher_discipline_id,
             query
           ) do
        {:ok, reviews} ->
          {:noreply, assign(socket, :reviews, reviews)}

        {:error, reason} ->
          {:noreply,
           socket
           |> put_flash(:error, "Failed to search reviews: #{reason}")}
      end
    else
      true ->
        {:noreply, assign_reviews(socket)}
    end
  end
end
