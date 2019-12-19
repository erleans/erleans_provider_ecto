defmodule ErleansProviderEcto do
  @moduledoc """
  Documentation for ErleansProviderEcto.
  """

  alias ErleansProviderEcto.Grain, as: Grain
  require Ecto.Query

  # @behaviour :erleans_provider

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
    ErleansProviderEcto.Repo.put_dynamic_repo(repo)

    %Grain{
      grain_id: id,
      grain_type: type,
      grain_ref_hash: Grain.ref_hash(id, type),
      grain_etag: etag,
      grain_state: state
    }
    |> Grain.changeset()
    |> ErleansProviderEcto.Repo.insert()
  end

  def insert(_type, _repo, _id, _hash, _state, _etag) do
    # ErleansProviderEcto.Repo.put_dynamic_repo(repo)
  end

  def update(type, repo, id, state, etag, new_etag) do
    ErleansProviderEcto.Repo.put_dynamic_repo(repo)
    hash = Grain.ref_hash(id, type)

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
  end

  def update(_type, _repo, _id, _hash, _state, _etag, _new_etag) do
    # ErleansProviderEcto.Repo.put_dynamic_repo(repo)
  end
end
