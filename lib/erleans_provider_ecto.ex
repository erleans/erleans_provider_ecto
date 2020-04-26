defmodule ErleansProviderEcto do
  @moduledoc """
  Documentation for ErleansProviderEcto.
  """

  alias ErleansProviderEcto.Grain, as: Grain
  require Ecto.Query

  # @behaviour :erleans_provider

  def start_link(repo_name, repo_module, opts) do
    repo_module.start_link([{:name, repo_name} | opts])
  end

  def all(type, repo_name, repo_module) do
    repo_module.put_dynamic_repo(repo_name)
    repo_module.all(Ecto.Query.from(g in Grain, where: g.grain_type == ^type))
  end

  def read(type, repo_name, repo_module, id) do
    repo_module.put_dynamic_repo(repo_name)

    case repo_module.get_by(Grain, grain_id: id, grain_type: type) do
      nil ->
        {:error, :not_found}

      %{:grain_etag => etag, :grain_state => state} ->
        {:ok, state, etag}
    end
  end

  def read_by_hash(type, repo_name, repo_module, hash) do
    repo_module.put_dynamic_repo(repo_name)

    case repo_module.get_by(Grain, grain_type: type, grain_etag: hash) do
      nil ->
        {:error, :not_found}

      g ->
        {:ok, g}
    end
  end

  def insert(type, repo_name, repo_module, id, state, etag) do
    insert(type, repo_name, repo_module, id, Grain.ref_hash(id, type), state, etag)
  end

  def insert(type, repo_name, repo_module, id, hash, state, etag) do
    repo_module.put_dynamic_repo(repo_name)

    %Grain{
      grain_id: id,
      grain_type: type,
      grain_ref_hash: hash,
      grain_etag: etag,
      grain_state: state
    }
    |> Grain.changeset()
    |> repo_module.insert()
  end

  def update(type, repo_name, repo_module, id, state, etag, new_etag) do
    update(type, repo_name, repo_module, id, Grain.ref_hash(id, type), state, etag, new_etag)
  end

  def update(type, repo_name, repo_module, id, hash, state, etag, new_etag) do
    repo_module.put_dynamic_repo(repo_name)

    repo_module.update_all(
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
