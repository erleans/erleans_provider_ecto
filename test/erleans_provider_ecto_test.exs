defmodule ErleansProviderEctoTest do
  use ExUnit.Case
  doctest ErleansProviderEcto

  alias ErleansProviderEcto.Grain, as: Grain

  setup_all do
    repo = :myrepo

    ErleansProviderEcto.start_link(repo,
      database: "test",
      username: "test",
      hostname: "localhost",
      pool: Ecto.Adapters.SQL.Sandbox,
      adapter: Ecto.Adapters.Postgres
    )

    Ecto.Migrator.run(
      ErleansProviderEcto.Repo,
      "priv/repo/migrations",
      :up,
      dynamic_repo: repo,
      all: true
    )

    [repo: repo]
  end

  setup state do
    repo = state[:repo]

    Ecto.Adapters.SQL.Sandbox.mode(repo, :manual)

    ErleansProviderEcto.Repo.put_dynamic_repo(repo)
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(repo)

    {:ok, repo: repo}
  end

  test "invalid data returns error changeset", state do
    repo = state[:repo]
    ErleansProviderEcto.Repo.put_dynamic_repo(repo)

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
      |> ErleansProviderEcto.Repo.insert()

    expected_error = [grain_etag: {"can't be blank", [validation: :required]}]
    assert {:error, %Ecto.Changeset{errors: ^expected_error}} = result
  end

  test "basic insert of grain", state do
    repo = state[:repo]

    id = "hello"
    type = TestGrain

    result = ErleansProviderEcto.insert(type, repo, id, "state", 0)

    assert {:ok, _} = result
  end

  test "compare and swap grain state", state do
    repo = state[:repo]
    ErleansProviderEcto.Repo.put_dynamic_repo(repo)

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
      |> ErleansProviderEcto.Repo.insert()

    assert {:ok, _} = result

    {:ok, %ErleansProviderEcto.Grain{grain_etag: etag}} = ErleansProviderEcto.read(type, repo, id)
    assert 0 = etag

    new_state = "hello"
    new_etag = 1
    ErleansProviderEcto.update(type, repo, id, new_state, etag, new_etag)

    {:ok, %ErleansProviderEcto.Grain{grain_etag: check_etag}} =
      ErleansProviderEcto.read(type, repo, id)

    assert 1 = check_etag
  end
end
