defmodule MinhaUniversidadeWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [MinhaUniversidade.Universities],
    open_api: "/open_api"
end
