defmodule MinhaUniversidadeWeb.PageController do
  use MinhaUniversidadeWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
