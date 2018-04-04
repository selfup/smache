defmodule SmacheWeb.ApiControllerTest do
  alias Smache.Cache.Shard.Model, as: Shard
  use SmacheWeb.ConnCase

  setup do
    Shard.tables(:ets)
    |> Enum.each(fn t -> :ets.delete_all_objects(t) end)        
  end

  def post_query(id) do
    build_conn() |> post("/api", id: id, data: %{color: "blue"})
  end

  def get_query(id) do
    build_conn() |> get("/api", id: id)
  end

  test "POST /api - keeps count to 1 when same user makes queries" do
    post_query(1)
    post_query(1)

    assert json_response(get_query(1), 200) == %{"id" => 1, "data" => %{"color" => "blue"}}
  end

  test "POST /api - slam api" do
    cold_time = :os.system_time(:seconds)

    0..50_000
    |> Enum.map(fn i -> Task.async(fn -> post_query(i) end) end)
    |> Enum.each(fn t -> Task.await(t) end)

    IO.puts("\n Cold slam seconds: #{:os.system_time(:seconds) - cold_time}")

    assert json_response(get_query(20_000), 200) == %{
             "id" => 20_000,
             "data" => %{"color" => "blue"}
           }

    warm_time = :os.system_time(:seconds)

    0..50_000
    |> Enum.map(fn i -> Task.async(fn -> get_query(i) end) end)
    |> Enum.each(fn t -> Task.await(t) end)

    IO.puts(" Warm slam seconds: #{:os.system_time(:seconds) - warm_time}")

    assert json_response(get_query(10_000), 200) == %{
             "id" => 10_000,
             "data" => %{"color" => "blue"}
           }
  end
end
