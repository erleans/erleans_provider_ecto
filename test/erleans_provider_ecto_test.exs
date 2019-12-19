defmodule ErleansProviderEctoTest do
  use ExUnit.Case
  doctest ErleansProviderEcto

  alias ErleansProviderEcto.Grain, as: Grain

  setup do
    ErleansProviderEcto.Repo.start_link(name: :myrepo, database: "test", username: "test", hostname: "localhost", pool: Ecto.Adapters.SQL.Sandbox, adapter: Ecto.Adapters.Postgres)
    Ecto.Adapters.SQL.Sandbox.mode(:myrepo, :manual)

    ErleansProviderEcto.Repo.put_dynamic_repo(:myrepo)
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(:myrepo)
  end

  test "basic insert of grain" do
    id = "hello"
    type = "test-grain"
    repo = ErleansProviderEcto.Repo

    result = ErleansProviderEcto.insert(id, repo, type, "state", 0)

    assert {:ok, _} = result
  end

  test "invalid data returns error changeset" do
    id = "failing-grain"
    type = "missing-etag"
    ref_hash = ErleansProviderEcto.Grain.ref_hash(id, type)
    missing_etag = %Grain{grain_id: id,
                          grain_type: type,
                          grain_ref_hash: ref_hash,
                          grain_state: "state"}

    result = missing_etag |>
      ErleansProviderEcto.Grain.changeset() |>
      ErleansProviderEcto.Repo.insert()

    expected_error = [grain_etag: {"can't be blank", [validation: :required]}]
    assert {:error, %Ecto.Changeset{errors: ^expected_error}} = result
  end

  test "compare and swap grain state" do
    repo = ErleansProviderEcto.Repo
    type = "test-grain"
    id = "hello"
    g = %ErleansProviderEcto.Grain{grain_id: id,
                                   grain_type: type,
                                   grain_ref_hash: ErleansProviderEcto.Grain.ref_hash(id, type),
                                   grain_etag: 0,
                                   grain_state: "state"}

    result = g |>
      ErleansProviderEcto.Grain.changeset() |>
      ErleansProviderEcto.Repo.insert()

    assert {:ok, _} = result

    {:ok, %ErleansProviderEcto.Grain{grain_etag: etag}} = ErleansProviderEcto.read(type, repo, id)
    assert 0 = etag

    new_state = "hello"
    new_etag = 1
    ErleansProviderEcto.update(type, repo, id, new_state, etag, new_etag)

    {:ok, %ErleansProviderEcto.Grain{grain_etag: check_etag}} = ErleansProviderEcto.read(type, repo, id)
    assert 1 = check_etag
  end
end
