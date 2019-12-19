defmodule ErleansProviderEcto do
  @moduledoc """
  Documentation for ErleansProviderEcto.
  """

  alias ErleansProviderEcto.Grain, as: Grain
  require Ecto.Query

  # @behaviour :erleans_provider

  def all(type, repo) do
    repo.all(Ecto.Query.from g in Grain, where: g.grain_type == ^type)
  end

  def read(type, repo, id) do
    case repo.get_by(Grain, grain_id: id, grain_type: type) do
      nil ->
        {:error, :not_found}
      grains ->
        {:ok, grains}
    end
  end

  def read_by_hash(type, repo, hash) do
    case repo.get_by(Grain, grain_type: type, grain_etag: hash) do
      nil ->
        {:error, :not_found}
      g ->
        {:ok, g}
    end
  end

  def insert(type, repo, id, state, etag) do
    %Grain{grain_id: id,
           grain_type: type,
           grain_ref_hash: Grain.ref_hash(id, type),
           grain_etag: etag,
           grain_state: state} |>
      Grain.changeset() |>
      repo.insert()
  end

  def insert(_type, _repo, _id, _hash, _state, _etag) do
  end

  def update(type, repo, id, state, etag, new_etag) do
    hash = Grain.ref_hash(id, type)
    repo.update_all(
      Ecto.Query.from(
        g in Grain,
        where: g.grain_ref_hash == ^hash and
        g.grain_id == ^id and
        g.grain_type == ^type and
        g.grain_etag == ^etag,
      update: [set: [grain_etag: ^new_etag,
                     grain_state: ^state,
                     updated_at: fragment("CURRENT_TIMESTAMP")]]), [])
  end

  def update(_type, _repo, _id, _hash, _state, _etag, _new_etag) do

  end
end
