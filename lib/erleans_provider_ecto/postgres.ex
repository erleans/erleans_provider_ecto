defmodule ErleansProviderEcto.Postgres do
  @moduledoc """
  Documentation for ErleansProviderEcto.Postgres.
  """

  # @behaviour :erleans_provider

  def start_link(repo, opts) do
    ErleansProviderEcto.start_link(repo, ErleansProviderEcto.PostgresRepo, opts)
  end

  def all(type, repo) do
    ErleansProviderEcto.all(type, repo, ErleansProviderEcto.PostgresRepo)
  end

  def read(type, repo, id) do
    ErleansProviderEcto.read(type, repo, ErleansProviderEcto.PostgresRepo, id)
  end

  def read_by_hash(type, repo, hash) do
    ErleansProviderEcto.read_by_hash(type, repo, ErleansProviderEcto.PostgresRepo, hash)
  end

  def insert(type, repo, id, state, etag) do
    ErleansProviderEcto.insert(type, repo, ErleansProviderEcto.PostgresRepo, id, state, etag)
  end

  def insert(type, repo, id, hash, state, etag) do
    ErleansProviderEcto.insert(
      type,
      repo,
      ErleansProviderEcto.PostgresRepo,
      id,
      hash,
      state,
      etag
    )
  end

  def update(type, repo, id, state, etag, new_etag) do
    ErleansProviderEcto.update(
      type,
      repo,
      ErleansProviderEcto.PostgresRepo,
      id,
      state,
      etag,
      new_etag
    )
  end

  def update(type, repo, id, hash, state, etag, new_etag) do
    ErleansProviderEcto.update(
      type,
      repo,
      ErleansProviderEcto.PostgresRepo,
      id,
      hash,
      state,
      etag,
      new_etag
    )
  end
end
