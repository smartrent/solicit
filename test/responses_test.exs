defmodule Solicit.ResponsesTest do
  use ExUnit.Case, async: true

  import Plug.Conn
  import Phoenix.ConnTest

  alias Solicit.Responses

  describe "ok" do
    test "Should return 200" do
      build_conn()
      |> Responses.ok()
      |> json_response(:ok)
    end
  end

  describe "created" do
    test "Should return 201" do
      response =
        build_conn()
        |> Responses.created(%{})
        |> json_response(:created)

      assert response == %{}
    end
  end

  describe "accepted" do
    test "Should return 202" do
      response =
        build_conn()
        |> Responses.accepted("test")
        |> json_response(:accepted)

      assert response == %{"details" => "test"}
    end
  end

  describe "no_content" do
    test "Should return 204" do
      assert Responses.no_content(build_conn()).status == 204
    end
  end

  describe "bad_request" do
    test "Should return 400" do
      build_conn()
      |> Responses.bad_request()
      |> json_response(:bad_request)
    end
  end

  describe "unauthorized" do
    test "Should return 401" do
      build_conn()
      |> Responses.unauthorized()
      |> json_response(:unauthorized)
    end
  end

  describe "forbidden" do
    test "Should return 403" do
      build_conn()
      |> Responses.forbidden()
      |> json_response(:forbidden)
    end
  end

  describe "conflict" do
    test "Should return 409" do
      response =
        build_conn()
        |> Responses.conflict("test")
        |> json_response(:conflict)

      assert response["errors"] == [%{"code" => "conflict", "description" => "test"}]
    end
  end

  describe "unprocessable_entity" do
    test "Should return 422" do
      build_conn()
      |> Responses.unprocessable_entity()
      |> json_response(:unprocessable_entity)
    end
  end

  describe "internal_server_error" do
    test "Should return 500" do
      response =
        build_conn()
        |> Responses.internal_server_error("test")
        |> json_response(:internal_server_error)

      assert response["errors"] == ["test"]
    end
  end
end
