ExUnit.start()

case System.get_env("GITHUB_ACTIONS", nil) do
  nil ->
    Application.ensure_all_started(:myxql)
  _ ->
    nil
end

Application.ensure_all_started(:postgrex)
Application.ensure_all_started(:ecto_sql)
Application.ensure_all_started(:erleans_provider_ecto)
