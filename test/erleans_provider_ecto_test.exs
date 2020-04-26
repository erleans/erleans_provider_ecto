defmodule ErleansProviderEctoTest do
  use ExUnit.Case

  alias ErleansProviderEcto.Grain, as: Grain

  @configs [
    {:pgrepo, ErleansProviderEcto.Postgres, ErleansProviderEcto.PostgresRepo,
     "priv/postgres_repo/migrations"} |
    case System.get_env("GITHUB_ACTIONS", nil) do
      nil ->
        [{:myrepo, ErleansProviderEcto.MySQL, ErleansProviderEcto.MySQLRepo,
          "priv/mysql_repo/migrations"}]
      _ ->
        []
    end
  ]

  def init_sandbox(state) do
    {repo_name, provider_module, repo_module} = state[:repo]

    Ecto.Adapters.SQL.Sandbox.mode(repo_name, :manual)

    repo_module.put_dynamic_repo(repo_name)
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(repo_name)

    {:ok, repo: {repo_name, provider_module, repo_module}}
  end

  @configs
  |> Enum.each(fn {repo_name, provider_module, repo_module, migrations_dir} ->
    describe "#{provider_module} tests" do
      setup do
        {repo_name, provider_module, repo_module, migrations_dir} =
          {unquote(repo_name), unquote(provider_module), unquote(repo_module),
           unquote(migrations_dir)}

        provider_module.start_link(repo_name,
          database: "testdb",
          username: "test",
          password: "test",
          hostname: "127.0.0.1",
          protocol: :tcp,
          pool: Ecto.Adapters.SQL.Sandbox,
          adapter: Ecto.Adapters.Postgres
        )

        Ecto.Migrator.run(
          repo_module,
          migrations_dir,
          :up,
          dynamic_repo: repo_name,
          all: true
        )

        [repo: {repo_name, provider_module, repo_module}]
      end

      test "invalid data returns error changeset", state do
        init_sandbox(state)

        {repo_name, _provider_module, repo_module} = state[:repo]
        repo_module.put_dynamic_repo(repo_name)

        id = "failing-grain"
        type = MissingEtag
        ref_hash = ErleansProviderEcto.Grain.ref_hash(id, type)

        missing_etag = %Grain{
          grain_id: id,
          grain_type: type,
          grain_ref_hash: ref_hash,
          grain_state: "state"
        }

        result =
          missing_etag
          |> ErleansProviderEcto.Grain.changeset()
          |> repo_module.insert()

        expected_error = [grain_etag: {"can't be blank", [validation: :required]}]
        assert {:error, %Ecto.Changeset{errors: ^expected_error}} = result
      end

      test "basic insert of grain", state do
        init_sandbox(state)
        {repo_name, provider_module, _repo_module} = state[:repo]

        id = "hello"
        type = TestGrain

        result = provider_module.insert(type, repo_name, id, "state", 0)

        assert {:ok, _} = result
      end

      test "compare and swap grain state", state do
        init_sandbox(state)
        {repo_name, provider_module, repo_module} = state[:repo]
        repo_module.put_dynamic_repo(repo_name)

        id = "hello"
        type = TestGrain

        g = %ErleansProviderEcto.Grain{
          grain_id: id,
          grain_type: type,
          grain_ref_hash: ErleansProviderEcto.Grain.ref_hash(id, type),
          grain_etag: 0,
          grain_state: "state"
        }

        result =
          g
          |> ErleansProviderEcto.Grain.changeset()
          |> repo_module.insert()

        assert {:ok, _} = result

        {:ok, _, etag} =
          provider_module.read(type, repo_name, id)

        assert 0 = etag

        new_state = "hello"
        new_etag = 1
        provider_module.update(type, repo_name, id, new_state, etag, new_etag)

        {:ok, _, check_etag} =
          provider_module.read(type, repo_name, id)

        assert 1 = check_etag
      end
    end
  end)
end
