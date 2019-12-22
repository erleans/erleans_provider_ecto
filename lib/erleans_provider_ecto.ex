defmodule ErleansProviderEcto do
  @moduledoc """
  Documentation for ErleansProviderEcto.
  """

  alias ErleansProviderEcto.Grain, as: Grain
  require Ecto.Query

  # @behaviour :erleans_provider

  def start_link(name, opts) do
    ErleansProviderEcto.Repo.start_link([{:name, name} | opts])
  end

  def all(type, repo) do
    ErleansProviderEcto.Repo.put_dynamic_repo(repo)
    ErleansProviderEcto.Repo.all(Ecto.Query.from(g in Grain, where: g.grain_type == ^type))
  end

  def read(type, repo, id) do
    ErleansProviderEcto.Repo.put_dynamic_repo(repo)

    case ErleansProviderEcto.Repo.get_by(Grain, grain_id: id, grain_type: type) do
      nil ->
        {:error, :not_found}

      grains ->
        {:ok, grains}
    end
  end

  def read_by_hash(type, repo, hash) do
    ErleansProviderEcto.Repo.put_dynamic_repo(repo)

    case ErleansProviderEcto.Repo.get_by(Grain, grain_type: type, grain_etag: hash) do
      nil ->
        {:error, :not_found}

      g ->
        {:ok, g}
    end
  end

  def insert(type, repo, id, state, etag) do
    insert(type, repo, id, Grain.ref_hash(id, type), state, etag)
  end

  def insert(type, repo, id, hash, state, etag) do
    ErleansProviderEcto.Repo.put_dynamic_repo(repo)

    %Grain{
      grain_id: id,
      grain_type: type,
      grain_ref_hash: hash,
      grain_etag: etag,
      grain_state: state
    }
    |> Grain.changeset()
    |> ErleansProviderEcto.Repo.insert()
  end

  def update(type, repo, id, state, etag, new_etag) do
    update(type, repo, id, Grain.ref_hash(id, type), state, etag, new_etag)
  end

  def update(type, repo, id, hash, state, etag, new_etag) do
    ErleansProviderEcto.Repo.put_dynamic_repo(repo)

    ErleansProviderEcto.Repo.update_all(
      Ecto.Query.from(g in Grain,
        where:
          g.grain_ref_hash == ^hash and
            g.grain_id == ^id and
            g.grain_type == ^type and
            g.grain_etag == ^etag,
        update: [
          set: [
            grain_etag: ^new_etag,
            grain_state: ^state,
            updated_at: fragment("CURRENT_TIMESTAMP")
          ]
        ]
      ),
      []
    )
    :ok
  end
end
