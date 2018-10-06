defmodule SmacheWeb.ApiControllerTest do
  use SmacheWeb.ConnCase

  setup do
    :ets.delete_all_objects(:smache_cache) && :ok
  end

  def post_query(key) do
    build_conn() |> post("/api", key: key, data: %{color: "blue"})
  end

  def get_query(key) do
    build_conn() |> get("/api", key: key)
  end

  def nil_query() do
    build_conn() |> get("/api", key: nil)
  end

  test "POST /api - keeps count when same user makes queries" do
    post_query(1)
    post_query(1)

    assert json_response(get_query(1), 200) == %{
             "data" => %{"color" => "blue"},
             "key" => 1,
             "node" => "nonode@nohost"
           }

    post_query(2)
    post_query(2)

    assert json_response(get_query(2), 200) == %{
             "data" => %{"color" => "blue"},
             "key" => 2,
             "node" => "nonode@nohost"
           }
  end

  test "POST /api - can handle unsigned" do
    post_query("aaaa")

    assert json_response(get_query("aaaa"), 200) == %{
             "data" => %{"color" => "blue"},
             "key" => "aaaa",
             "node" => "nonode@nohost"
           }
  end

  test "GET /api - returns 403 on nil/null key" do
    assert json_response(nil_query(), 405) == %{"message" => "key cannot be null"}
  end
end
