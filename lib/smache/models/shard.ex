defmodule Smache.Cache.Shard.Model do
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

  def is_num_or_str?(key) do
    case is_number(key) do
      true ->
        key

      false ->
        case is_binary(key) do
          true ->
            {num_key, _} = Integer.parse(key, 10)

            num_key

          false ->
            {num_key, _} = Integer.parse(key)

            num_key
        end
    end
  end
end
