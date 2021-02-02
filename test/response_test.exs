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

  describe "accepted/1" do
    test "Should return 202" do
      response =
        build_conn()
        |> Response.accepted()
        |> json_response(:accepted)

      assert response == nil
    end
  end

  describe "accepted/2" do
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

    test "Should return 401 with custom errors" do
      response =
        build_conn()
        |> Response.unauthorized([
          %{
            code: "invalid",
            description: "Invalid code"
          }
        ])
        |> json_response(:unauthorized)

      assert response == %{"errors" => [%{"code" => "invalid", "description" => "Invalid code"}]}
    end
  end

  describe "forbidden" do
    test "Should return 403" do
      build_conn()
      |> Response.forbidden()
      |> json_response(:forbidden)
    end

    test "Should return 403 with custom errors" do
      response =
        build_conn()
        |> Response.forbidden([
          %{
            code: "lockout",
            description: "Too many attempts, please try again later"
          }
        ])
        |> json_response(:forbidden)

      assert response == %{
               "errors" => [
                 %{
                   "code" => "lockout",
                   "description" => "Too many attempts, please try again later"
                 }
               ]
             }
    end
  end

  describe "not_found" do
    test "Should return 404" do
      build_conn()
      |> Response.not_found()
      |> json_response(:not_found)
    end

    test "Should return 404 with custom errors" do
      response =
        build_conn()
        |> Response.not_found([
          %{
            code: "not_found",
            description: "Re-enter username and password"
          }
        ])
        |> json_response(:not_found)

      assert response == %{
               "errors" => [
                 %{
                   "code" => "not_found",
                   "description" => "Re-enter username and password"
                 }
               ]
             }
    end
  end

  describe "method_not_allowed" do
    test "Should return 405" do
      response =
        build_conn()
        |> Response.method_not_allowed()
        |> json_response(:method_not_allowed)

      assert response["errors"] == [
               %{"code" => "method_not_allowed", "description" => "Method is not allowed."}
             ]
    end

    test "Should return 405 with custom errors" do
      response =
        build_conn()
        |> Response.method_not_allowed([
          %{
            code: "method_not_allowed",
            description: "resolution"
          }
        ])
        |> json_response(:method_not_allowed)

      assert response == %{
               "errors" => [
                 %{
                   "code" => "method_not_allowed",
                   "description" => "resolution"
                 }
               ]
             }
    end
  end

  describe "timeout" do
    test "Should return 408" do
      response =
        build_conn()
        |> Response.timeout()
        |> json_response(:request_timeout)

      assert response["errors"] == [%{"code" => "timeout", "description" => "Request timed out."}]
    end

    test "Should return 408 with custom errors" do
      response =
        build_conn()
        |> Response.timeout([
          %{
            code: "timeout",
            description: "resolution"
          }
        ])
        |> json_response(:request_timeout)

      assert response == %{
               "errors" => [
                 %{
                   "code" => "timeout",
                   "description" => "resolution"
                 }
               ]
             }
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

    test "Should return 409 with custom errors" do
      response =
        build_conn()
        |> Response.conflict([
          %{
            code: "conflict",
            description: "resolution"
          }
        ])
        |> json_response(:conflict)

      assert response == %{
               "errors" => [
                 %{
                   "code" => "conflict",
                   "description" => "resolution"
                 }
               ]
             }
    end
  end

  describe "unprocessable_entity" do
    test "Should return 422" do
      build_conn()
      |> Response.unprocessable_entity()
      |> json_response(:unprocessable_entity)
    end

    defmodule Foo do
      defstruct [:id, :name]
    end

    test "Should return 422 for a changeset" do
      changeset =
        {%Foo{}, %{id: :string, name: :string}}
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.validate_required([:id])

      response =
        build_conn()
        |> Response.unprocessable_entity(changeset)
        |> json_response(:unprocessable_entity)

      assert response == %{
               "errors" => [
                 %{
                   "code" => "unknown_error",
                   "description" => "can't be blank",
                   "field" => "id"
                 }
               ]
             }
    end

    test "Should return 422 with custom errors" do
      response =
        build_conn()
        |> Response.unprocessable_entity([
          %{
            code: "unprocessable_entity",
            description: "This was an error"
          }
        ])
        |> json_response(:unprocessable_entity)

      assert response == %{
               "errors" => [
                 %{
                   "code" => "unprocessable_entity",
                   "description" => "This was an error"
                 }
               ]
             }
    end
  end

  describe "too_many_requests" do
    test "Should return 429 with default error" do
      response =
        build_conn()
        |> Response.too_many_requests()
        |> json_response(:too_many_requests)

      assert response == %{
               "errors" => [
                 %{
                   "code" => "too_many_requests",
                   "description" => "Exceeded request threshold."
                 }
               ]
             }
    end

    test "Should return 429 with custom error message" do
      message = "You've exceeded the allowed threshold."

      response =
        build_conn()
        |> Response.too_many_requests(message)
        |> json_response(:too_many_requests)

      assert response == %{
               "errors" => [
                 %{
                   "code" => "too_many_requests",
                   "description" => message
                 }
               ]
             }
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

    test "Should return base 500 error" do
      response =
        build_conn()
        |> Response.internal_server_error()
        |> json_response(:internal_server_error)

      assert response == %{
               "errors" => [
                 %{
                   "code" => "internal_server_error",
                   "description" => "Internal Server Error"
                 }
               ]
             }
    end

    test "Should return custom 500 errors" do
      response =
        build_conn()
        |> Response.internal_server_error([
          %{
            code: "internal_server_error",
            description: "This was an error"
          }
        ])
        |> json_response(:internal_server_error)

      assert response == %{
               "errors" => [
                 %{
                   "code" => "internal_server_error",
                   "description" => "This was an error"
                 }
               ]
             }
    end
  end

  describe "has_all_fields" do
    test "Should allow custom functional fields that are not in result" do
      build_conn()
      |> Response.ok(
        %{records: [], current_page: 1, total_pages: 1, total_records: 0},
        [
          :records,
          :current_page,
          :total_pages,
          :total_records,
          test: fn _ -> "Test" end
        ]
      )
      |> json_response(:ok)
    end

    test "Should return the correct shape for object and sub structure when defined" do
      build_conn()
      |> Response.ok(
        %{
          space_number: "Test",
          vehicle: %{license_plate: "License Plate", state: "state"}
        },
        [
          :space_number,
          vehicle: [
            :license_plate,
            :state,
            test: fn _ -> "Test" end
          ]
        ]
      )
      |> json_response(:ok)
    end

    test "Should return the correct shape for a list of sub structures when defined" do
      build_conn()
      |> Response.ok(
        %{
          records: [
            %{space_number: "Test", vehicles: [%{license_plate: "License Plate", state: "state"}]}
          ],
          current_page: 1,
          total_pages: 1,
          total_records: 0
        },
        [
          :current_page,
          :total_pages,
          :total_records,
          records: [
            :space_number,
            vehicles: [
              :license_plate,
              :state,
              test: fn _ -> "Test" end
            ]
          ]
        ]
      )
      |> json_response(:ok)
    end

    test "Should return the correct shape if substructure is not passed" do
      build_conn()
      |> Response.ok(
        %{
          records: [
            %{space_number: "Test", vehicles: [%{license_plate: "License Plate", state: "state"}]}
          ],
          current_page: 1,
          total_pages: 1,
          total_records: 0
        },
        [
          :current_page,
          :total_pages,
          :total_records,
          records: [
            :space_number,
            :vehicles
          ]
        ]
      )
      |> json_response(:ok)
    end

    test "Should raise error for malformed fields when sub fields passed don't match result" do
      assert_raise(RuntimeError, fn ->
        Response.ok(
          build_conn(),
          %{
            records: [
              %{space_number: "Test", vehicle: "Test"}
            ],
            current_page: 1,
            total_pages: 1,
            total_records: 0
          },
          [
            :current_page,
            :total_pages,
            :total_records,
            records: [
              :space_number,
              vehicle: [
                :license_plate,
                :state
              ]
            ]
          ]
        )
      end)
    end
  end
end
