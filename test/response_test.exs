defmodule Solicit.ResponseTest do
  use ExUnit.Case, async: true

  import Phoenix.ConnTest

  alias Solicit.Response

  describe "ok" do
    test "Should return 200" do
      build_conn()
      |> Response.ok()
      |> json_response(:ok)
    end

    test "Should return the correct shape" do
      response =
        build_conn()
        |> Response.ok(%{records: [], current_page: 1, total_pages: 1, total_records: 0}, [
          :records,
          :current_page,
          :total_pages,
          :total_records
        ])
        |> json_response(:ok)

      assert response == %{
               "current_page" => 1,
               "records" => [],
               "total_pages" => 1,
               "total_records" => 0
             }
    end

    test "Should raise error" do
      assert_raise(RuntimeError, fn ->
        Response.ok(
          build_conn(),
          %{records: [], current_page: 1, total_pages: 1, total_records: 0},
          [
            :records,
            :current_page,
            :total_pages,
            :total_records,
            :test
          ]
        )
      end)
    end
  end

  describe "created" do
    test "Should return 201" do
      response =
        build_conn()
        |> Response.created(%{})
        |> json_response(:created)

      assert response == %{}
    end

    test "Should raise error" do
      assert_raise(RuntimeError, fn ->
        Response.created(
          build_conn(),
          %{records: [], current_page: 1, total_pages: 1, total_records: 0},
          [
            :records,
            :current_page,
            :total_pages,
            :total_records,
            :test
          ]
        )
      end)
    end
  end

  describe "accepted" do
    test "Should return 202" do
      response =
        build_conn()
        |> Response.accepted("test")
        |> json_response(:accepted)

      assert response == %{"details" => "test"}
    end
  end

  describe "no_content" do
    test "Should return 204" do
      assert Response.no_content(build_conn()).status == 204
    end
  end

  describe "bad_request" do
    test "Should return 400" do
      build_conn()
      |> Response.bad_request()
      |> json_response(:bad_request)
    end
  end

  describe "unauthorized" do
    test "Should return 401" do
      build_conn()
      |> Response.unauthorized()
      |> json_response(:unauthorized)
    end
  end

  describe "forbidden" do
    test "Should return 403" do
      build_conn()
      |> Response.forbidden()
      |> json_response(:forbidden)
    end
  end

  describe "conflict" do
    test "Should return 409" do
      response =
        build_conn()
        |> Response.conflict("test")
        |> json_response(:conflict)

      assert response["errors"] == [%{"code" => "conflict", "description" => "test"}]
    end
  end

  describe "unprocessable_entity" do
    test "Should return 422" do
      build_conn()
      |> Response.unprocessable_entity()
      |> json_response(:unprocessable_entity)
    end
  end

  describe "internal_server_error" do
    test "Should return 500" do
      response =
        build_conn()
        |> Response.internal_server_error("test")
        |> json_response(:internal_server_error)

      assert response["errors"] == ["test"]
    end
  end
end
