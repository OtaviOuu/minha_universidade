defmodule MinhaUniversidade.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MinhaUniversidadeWeb.Telemetry,
      MinhaUniversidade.Repo,
      {DNSCluster,
       query: Application.get_env(:minha_universidade, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MinhaUniversidade.PubSub},
      # Start a worker by calling: MinhaUniversidade.Worker.start_link(arg)
      # {MinhaUniversidade.Worker, arg},
      # Start to serve requests, typically the last entry
      MinhaUniversidadeWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :minha_universidade]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MinhaUniversidade.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MinhaUniversidadeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
