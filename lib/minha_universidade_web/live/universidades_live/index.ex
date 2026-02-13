defmodule MinhaUniversidadeWeb.UniversidadesLive.Index do
  use MinhaUniversidadeWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_universities

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        Universidades
        <:subtitle>
          Explore as universidades disponíveis e encontre a instituição perfeita para sua jornada acadêmica.
        </:subtitle>
      </.header>

      <section>
        <.async_result :let={universities} assign={@universities}>
          <:loading>Carregando universidades...</:loading>
          <:failed :let={_failure}>error</:failed>
          <.universities_list universities={universities} />
        </.async_result>
      </section>
    </Layouts.app>
    """
  end

  defp universities_list(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <div class="grid grid-cols-2 gap-px overflow-hidden rounded-lg *:bg-gray-100 md:grid-cols-4">
        <.university_item :for={university <- @universities} university={university} />
      </div>
    </div>
    """
  end

  defp university_item(assigns) do
    ~H"""
    <.link
      navigate={~p"/universidades/#{@university.acronym}/disciplinas-professores"}
      class="grid aspect-video place-content-center p-4 grayscale transition-[filter] hover:grayscale-0"
    >
      <img src={@university.logo_url} alt="USP" class="h-16 w-auto object-contain" />
    </.link>
    """
  end

  defp assign_universities(socket) do
    assign_async(socket, :universities, fn ->
      {:ok, %{universities: MinhaUniversidade.Universities.list_universities!()}}
    end)
  end
end
