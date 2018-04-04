defmodule Smache.Cmd.Model do
  def exe(query, keys, data) do
    case query do
      _not_supported ->
        :error
    end
  end
end
