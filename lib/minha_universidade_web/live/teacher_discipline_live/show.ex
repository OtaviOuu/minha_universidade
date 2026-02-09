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
      <.header>Unidade de avaliação</.header>
      <.form for={@review_form} phx-submit="submit_review">
        <.input
          field={@review_form[:rating]}
          type="number"
          min="1"
          max="5"
          step="1"
          placeholder="Nota"
        />
        <.button type="submit">Enviar avaliação</.button>
      </.form>
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

  def assign_review_form(socket) do
    form =
      MinhaUniversidade.Universities.form_to_create_review(actor: socket.assigns.current_user)
      |> to_form

    socket
    |> assign(:review_form, form)
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
