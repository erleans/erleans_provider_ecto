defmodule ErleansProviderEcto.GrainId do
  use Ecto.Type

  def type() do
    :term
  end

  def cast(type) do
    {:ok, type}
  end

  def load(binary) when is_binary(binary) do
    {:ok, :erlang.binary_to_term(binary)}
  end

  def dump(id) do
    {:ok, :erlang.term_to_binary(id)}
  end
end

defmodule ErleansProviderEcto.GrainState do
  use Ecto.Type

  def type() do
    :term
  end

  def cast(term) do
    {:ok, term}
  end

  def load(binary) when is_binary(binary) do
    {:ok, :erlang.binary_to_term(binary)}
  end

  def dump(term) do
    {:ok, :erlang.term_to_binary(term)}
  end
end

defmodule ErleansProviderEcto.GrainType do
  use Ecto.Type

  def type() do
    :atom
  end

  def cast(type) do
    {:ok, type}
  end

  def load(type) when is_binary(type) do
    {:ok, String.to_existing_atom(type)}
  end

  def dump(type) do
    {:ok, Atom.to_string(type)}
  end
end
