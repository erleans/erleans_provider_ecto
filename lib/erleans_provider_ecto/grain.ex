defmodule ErleansProviderEcto.Grain do
  use Ecto.Schema

  @primary_key false
  schema "grain" do
    field(:grain_id, ErleansProviderEcto.GrainId, primary_key: true)
    field(:grain_type, ErleansProviderEcto.GrainType, primary_key: true)
    field(:grain_ref_hash, :integer)
    field(:grain_etag, :integer)
    field(:grain_state, ErleansProviderEcto.GrainState)
    timestamps()
  end

  def changeset(grain, params \\ %{}) do
    # TODO: Validate phash2 of id/type and ref_hash match
    grain
    |> Ecto.Changeset.cast(params, [
      :grain_id,
      :grain_type,
      :grain_ref_hash,
      :grain_etag,
      :grain_state
    ])
    |> Ecto.Changeset.validate_required([
      :grain_id,
      :grain_type,
      :grain_ref_hash,
      :grain_etag,
      :grain_state
    ])
    |> Ecto.Changeset.validate_length(:grain_type, max: 2048)
  end

  def ref_hash(id, type) do
    :erlang.phash2({id, type})
  end
end
