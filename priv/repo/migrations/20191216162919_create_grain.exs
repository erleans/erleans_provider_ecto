defmodule Erleans.Provider.Ecto.Repo.Migrations.CreateGrain do
  use Ecto.Migration

  def change do
    create table(:grain, primary_key: false) do
      add :grain_id, :binary, primary_key: true
      add :grain_type, :string, size: 2048, primary_key: true
      add :grain_ref_hash, :bigint
      add :grain_etag, :bigint
      add :grain_state, :binary
      timestamps()
    end
  end
end
