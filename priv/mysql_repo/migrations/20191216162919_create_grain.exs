defmodule ErleansProviderEcto.MySQLRepo.Migrations.CreateGrain do
  use Ecto.Migration

  def change do
    create table(:grain, primary_key: false) do
      add :grain_id, :varbinary, size: 1024, primary_key: true
      add :grain_type, :string, size: 1024, primary_key: true
      add :grain_ref_hash, :bigint
      add :grain_etag, :bigint
      add :grain_state, :binary
      timestamps()
    end
  end
end
