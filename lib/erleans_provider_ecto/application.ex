defmodule ErleansProviderEcto.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Erleans.Provider.Ecto.Repo
    ]

    opts = [strategy: :one_for_one, name: Grains.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
