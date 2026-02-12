defmodule MinhaUniversidadeWeb.PageController do
  use MinhaUniversidadeWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/universidades")
  end
end
