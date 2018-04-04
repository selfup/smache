defmodule Smache.Cache.Shard.Model do
  def shard_count_tables(type) do
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
end
