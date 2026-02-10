defmodule MinhaUniversidadeWeb.UniversidadesLive.Index do
  use MinhaUniversidadeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, universities} = MinhaUniversidade.Universities.list_universities()

    socket =
      socket
      |> assign(:universities, universities)

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
        <:actions>
          <.link navigate={~p"/"} class="btn btn-secondary">
            Voltar para a página inicial
          </.link>
        </:actions>
      </.header>

      <section>
        <.universities_list universities={@universities} />
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
end
