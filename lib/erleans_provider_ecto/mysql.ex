defmodule ErleansProviderEcto.MySQL do
  @moduledoc """
  Documentation for ErleansProviderEcto.MySQL.
  """

  # @behaviour :erleans_provider

  def start_link(repo, opts) do
    ErleansProviderEcto.start_link(repo, ErleansProviderEcto.MySQLRepo, opts)
  end

  def all(type, repo) do
    ErleansProviderEcto.all(type, repo, ErleansProviderEcto.MySQLRepo)
  end

  def read(type, repo, id) do
    ErleansProviderEcto.read(type, repo, ErleansProviderEcto.MySQLRepo, id)
  end

  def read_by_hash(type, repo, hash) do
    ErleansProviderEcto.read_by_hash(type, repo, ErleansProviderEcto.MySQLRepo, hash)
  end

  def insert(type, repo, id, state, etag) do
    ErleansProviderEcto.insert(type, repo, ErleansProviderEcto.MySQLRepo, id, state, etag)
  end

  def insert(type, repo, id, hash, state, etag) do
    ErleansProviderEcto.insert(type, repo, ErleansProviderEcto.MySQLRepo, id, hash, state, etag)
  end

  def update(type, repo, id, state, etag, new_etag) do
    ErleansProviderEcto.update(
      type,
      repo,
      ErleansProviderEcto.MySQLRepo,
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
      ErleansProviderEcto.MySQLRepo,
      id,
      hash,
      state,
      etag,
      new_etag
    )
  end
end
