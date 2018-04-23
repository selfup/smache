defmodule Smache.Shard do
  def tables(type) do
    case Integer.parse(System.get_env("SHARD_LIMIT") || "") do
      :error ->
        0..3 |> make_tables(type)

      {limit, _} ->
        0..(limit - 1) |> make_tables(type)
    end
  end

  def make_tables(nums, type) do
    Enum.map(nums, fn i ->
      :"#{to_string(type)}_table_#{i}"
    end)
  end

  def is_num_or_str?(key) when is_number(key) do
    key
  end

  def is_num_or_str?(key) do
    case Integer.parse(key) do
      {num, _} ->
        num

      :error ->
        :binary.decode_unsigned(key)
    end
  end
end
