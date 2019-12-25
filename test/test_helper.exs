ExUnit.start()

Application.ensure_all_started(:myxql)
Application.ensure_all_started(:postgrex)
Application.ensure_all_started(:ecto_sql)
Application.ensure_all_started(:erleans_provider_ecto)
