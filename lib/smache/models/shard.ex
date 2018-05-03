defmodule Smache.Shard do
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
