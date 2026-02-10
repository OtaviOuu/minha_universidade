defmodule MinhaUniversidadeWeb.UniversidadesLive.Show do
  use MinhaUniversidadeWeb, :live_view

  def mount(%{"university_acronym" => university_acronym}, _session, socket) do
    socket =
      socket
      |> assign(:university_acronym, university_acronym)
      |> assign_university(university_acronym)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Detalhes da Universidade
        <:subtitle>
          Explore as informações detalhadas sobre a universidade, incluindo seus cursos, localização e muito mais.
        </:subtitle>
        <:actions>
          <img
            src={@university.logo_url}
            alt="University logo"
            class="h-12  object-contain rounded-xl bg-base-200 p-2 shadow-sm"
          />
        </:actions>
      </.header>

      <section class="container mx-auto p-4">
        oi
      </section>
    </Layouts.app>
    """
  end

  defp assign_university(socket, university_acronym) do
    case MinhaUniversidade.Universities.get_university_by_acronym(university_acronym) do
      {:ok, university} ->
        assign(socket, :university, university)

      {:error, reason} ->
        socket
        |> put_flash(:error, "Failed to load university: #{reason}")
        |> push_navigate(to: ~p"/universidades")
    end
  end
end
