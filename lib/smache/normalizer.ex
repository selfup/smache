defmodule Smache.Normalizer do
  def normalize(key) when is_number(key) do
    key
  end

  def normalize(key) do
    case Integer.parse(key) do
      {num, _} ->
        num

      :error ->
        :binary.decode_unsigned(key)
    end
  end
end
