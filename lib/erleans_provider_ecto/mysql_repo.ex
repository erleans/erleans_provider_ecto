# TODO: actually support this. Need changes in Erleans first.
defmodule ErleansProviderEcto.MySQLRepo do
  use Ecto.Repo,
    otp_app: :erleans_provider_ecto,
    adapter: Ecto.Adapters.MyXQL
end
