defmodule ErleansProviderEcto.PostgresRepo do
  use Ecto.Repo,
    otp_app: :erleans_provider_ecto,
    adapter: Ecto.Adapters.Postgres
end
