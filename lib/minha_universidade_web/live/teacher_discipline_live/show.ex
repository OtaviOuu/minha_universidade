defmodule MinhaUniversidadeWeb.TeacherDisciplineLive.Show do
  use MinhaUniversidadeWeb, :live_view

  on_mount {MinhaUniversidadeWeb.LiveUserAuth, :current_user}
  on_mount {MinhaUniversidadeWeb.LiveUserAuth, :live_user_optional}

  def mount(%{"slug" => slug}, _session, socket) do
    socket =
      socket
      |> assign_teacher_discipline(slug)
      |> assign_review_form()

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Unidade de avaliação
        <:subtitle>
          Avalie para ajudar outros estudantes a escolherem as melhores opções para suas jornadas acadêmicas.
        </:subtitle>
        <:actions>
          <.icon name="hero-hand-thumb-up" class="text-secondary hover:text-primary cursor-pointer" />
        </:actions>
        <:actions>
          <.icon name="hero-hand-thumb-down" class="text-secondary hover:text-primary cursor-pointer" />
        </:actions>
      </.header>

      <section class="flex flex-col gap-4">
        <.teacher_discipline_review_badge teacher_discipline={@teacher_discipline} />

        <.discipline_teacher_data_card />

        <.form for={@review_form} phx-submit="submit_review">
          <div class="flex flex-row justify-between gap-4 mb-4">
            <.input
              field={@review_form[:rating]}
              type="number"
              min="1"
              max="5"
              step="1"
              label="Didática"
              placeholder="Nota"
              class="input input-secundary w-full"
            />
            <.input
              field={@review_form[:rating]}
              type="number"
              min="1"
              max="5"
              step="1"
              placeholder="Nota"
              label="Didática"
              class="input input-secundary w-full"
            />
            <.input
              field={@review_form[:rating]}
              type="number"
              min="1"
              max="5"
              step="1"
              placeholder="Nota"
              label="Didática"
              class="input input-secundary w-full"
            />
            <.input
              field={@review_form[:rating]}
              type="number"
              min="1"
              max="5"
              step="1"
              placeholder="Nota"
              label="Didática"
              class="input input-secundary w-full"
            />
            <.input
              field={@review_form[:rating]}
              type="number"
              min="1"
              max="5"
              step="1"
              label="Didática"
              placeholder="Nota"
              class="input input-secundary w-full"
            />
          </div>
          <div class="flex flex-row justify-between gap-4 mb-4">
            <.input
              field={@review_form[:rating]}
              type="checkbox"
              label="cobra presença?"
              placeholder="Nota"
            />
            <.input
              field={@review_form[:rating]}
              type="checkbox"
              label="cobra presença?"
              placeholder="Nota"
            />
            <.input
              field={@review_form[:rating]}
              type="checkbox"
              label="cobra presença?"
              placeholder="Nota"
            />
            <.input
              field={@review_form[:rating]}
              type="checkbox"
              label="cobra presença?"
              placeholder="Nota"
            />
          </div>
          <div>
            <.input
              field={@review_form[:rating]}
              type="textarea"
              label="Comentário geral"
              placeholder="Nota"
              class="input input-secundary w-full"
            />
            <.input
              field={@review_form[:rating]}
              type="textarea"
              label="Comentário avaliações"
              placeholder="Nota"
              class="input input-secundary w-full"
            />

            <.input
              field={@review_form[:rating]}
              type="textarea"
              label="Comentário presença"
              placeholder="Nota"
              class="input input-secundary w-full h-24"
            />
            <.input
              field={@review_form[:rating]}
              type="textarea"
              label="Comentário presença"
              placeholder="Nota"
              class="input input-secundary w-full h-24"
            />
          </div>

          <.button class="btn btn-primary mr-auto">Enviar avaliação</.button>
        </.form>
      </section>
    </Layouts.app>
    """
  end

  def discipline_teacher_data_card(assigns) do
    ~H"""
    <div class="stats stats-vertical lg:stats-horizontal shadow w-full">
      <div class="stat">
        <div class="stat-figure text-primary">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            class="inline-block h-8 w-8 stroke-current"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"
            >
            </path>
          </svg>
        </div>
        <div class="stat-title">Total Likes</div>
        <div class="stat-value text-primary">25.6K</div>
        <div class="stat-desc">21% more than last month</div>
      </div>

      <div class="stat">
        <div class="stat-figure text-secondary">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            class="inline-block h-8 w-8 stroke-current"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M13 10V3L4 14h7v7l9-11h-7z"
            >
            </path>
          </svg>
        </div>
        <div class="stat-title">Page Views</div>
        <div class="stat-value text-secondary">2.6M</div>
        <div class="stat-desc">21% more than last month</div>
      </div>

      <div class="stat">
        <div class="stat-figure text-secondary">
          <div class="avatar avatar-online">
            <div class="w-16 rounded-full">
              <img src="https://img.daisyui.com/images/profile/demo/anakeen@192.webp" />
            </div>
          </div>
        </div>
        <div class="stat-value">86%</div>
        <div class="stat-title">Tasks done</div>
        <div class="stat-desc text-secondary">31 tasks remaining</div>
      </div>
    </div>
    """
  end

  def assign_teacher_discipline(socket, slug) do
    case MinhaUniversidade.Universities.get_teacher_discipline_by_slug(slug,
           load: [:teacher, :discipline]
         ) do
      {:ok, teacher_discipline} ->
        assign(socket, :teacher_discipline, teacher_discipline)

      {:error, _reason} ->
        socket
        |> put_flash(:error, "Failed to load teacher discipline")
        |> push_navigate(to: ~p"/disciplinas-professores")
    end
  end

  def assign_review_form(socket) do
    form =
      MinhaUniversidade.Universities.form_to_create_review(actor: socket.assigns.current_user)
      |> to_form

    socket
    |> assign(:review_form, form)
  end

  attr :teacher_discipline, :map, required: true

  def teacher_discipline_review_badge(assigns) do
    ~H"""
    <div class="badge badge-primary badge-outline badge-info badge-xl">
      {@teacher_discipline.discipline.code} - {@teacher_discipline.discipline.name} - {@teacher_discipline.discipline.faculty.acronym} - {@teacher_discipline.teacher.name}
    </div>
    """
  end

  def handle_event("submit_review", %{"form" => review_params}, socket) do
    review_params =
      Map.put(review_params, "teacher_discipline_id", socket.assigns.teacher_discipline.id)

    dbg(review_params)

    case AshPhoenix.Form.submit(socket.assigns.review_form, params: review_params) do
      {:ok, review} ->
        dbg(review)

        socket =
          socket
          |> put_flash(:info, "Avaliação enviada com sucesso!")

        {:noreply, socket}

      {:error, form} ->
        dbg(form.errors)

        socket =
          socket
          |> assign(:review_form, form)
          |> put_flash(:error, "Failed to submit review")

        {:noreply, socket}
    end
  end
end
