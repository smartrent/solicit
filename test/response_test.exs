defmodule Solicit.ResponseTest do
  use ExUnit.Case, async: true

  import Phoenix.ConnTest

  alias Solicit.Response

  @custom_message "Custom message."

  describe "ok" do
    test "Should return 200" do
      build_conn()
      |> Response.ok()
      |> json_response(:ok)
    end

    test "Should return entire result if fields are not passed" do
      response =
        build_conn()
        |> Response.ok(%{records: [], current_page: 1, total_pages: 1, total_records: 0})
        |> json_response(:ok)

      assert response == %{
               "current_page" => 1,
               "records" => [],
               "total_pages" => 1,
               "total_records" => 0
             }
    end

    test "Should return on the fields passed" do
      response =
        build_conn()
        |> Response.ok(%{records: [], current_page: 1, total_pages: 1, total_records: 0}, [
          :records,
          :total_pages,
          :total_records
        ])
        |> json_response(:ok)

      assert response == %{
               "records" => [],
               "total_pages" => 1,
               "total_records" => 0
             }
    end

    test "Should return datetime as ISO string" do
      {:ok, date} = DateTime.new(~D[2016-05-24], ~T[13:26:08.003])

      response =
        build_conn()
        |> Response.ok(%{date: date}, [:date])
        |> json_response(:ok)

      assert response == %{
               "date" => "2016-05-24T13:26:08.003Z"
             }
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

    test "Should return on the fields passed" do
      response =
        build_conn()
        |> Response.created(%{license_plate: "Test", state: "VA"}, [
          :license_plate
        ])
        |> json_response(:created)

      assert response == %{
               "license_plate" => "Test"
             }
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

  describe "accepted/3" do
    test "Should return 202 with all fields by default" do
      response =
        build_conn()
        |> Response.accepted(%{license_plate: "Test", state: "VA"})
        |> json_response(:accepted)

      assert response == %{"license_plate" => "Test", "state" => "VA"}
    end

    test "Should return 202 with defined fields" do
      response =
        build_conn()
        |> Response.accepted(%{license_plate: "Test", state: "VA"}, [
          :license_plate
        ])
        |> json_response(:accepted)

      assert response == %{"license_plate" => "Test"}
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

    test "Should return 409 with default message" do
      response =
        build_conn()
        |> Response.conflict()
        |> json_response(:conflict)

      assert response["errors"] == [
               %{"code" => "conflict", "description" => "A conflict has occurred."}
             ]
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

  describe "gone" do
    test "Should return 410 with default error" do
      %{
        "errors" => [
          %{
            "code" => "gone",
            "description" => "Access to resource is no longer available."
          }
        ]
      } =
        build_conn()
        |> Response.gone()
        |> json_response(:gone)
    end

    test "Should return 410 with custom error message" do
      %{
        "errors" => [
          %{
            "code" => "gone",
            "description" => @custom_message
          }
        ]
      } =
        build_conn()
        |> Response.gone(@custom_message)
        |> json_response(:gone)
    end
  end

  describe "request_entity_too_large" do
    test "Should return 413 with default error" do
      %{
        "errors" => [
          %{
            "code" => "request_entity_too_large",
            "description" => "Request entity is too large."
          }
        ]
      } =
        build_conn()
        |> Response.request_entity_too_large()
        |> json_response(:request_entity_too_large)
    end

    test "Should return 413 with custom error message" do
      %{
        "errors" => [
          %{
            "code" => "request_entity_too_large",
            "description" => @custom_message
          }
        ]
      } =
        build_conn()
        |> Response.request_entity_too_large(@custom_message)
        |> json_response(:request_entity_too_large)
    end
  end

  describe "unsupported_media_type" do
    test "Should return 415 with default error" do
      %{
        "errors" => [
          %{
            "code" => "unsupported_media_type",
            "description" => "Request contains an unsupported media type."
          }
        ]
      } =
        build_conn()
        |> Response.unsupported_media_type()
        |> json_response(:unsupported_media_type)
    end

    test "Should return 415 with custom error message" do
      %{
        "errors" => [
          %{
            "code" => "unsupported_media_type",
            "description" => @custom_message
          }
        ]
      } =
        build_conn()
        |> Response.unsupported_media_type(@custom_message)
        |> json_response(:unsupported_media_type)
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

  describe "bad_gateway" do
    test "Should return 502" do
      response =
        build_conn()
        |> Response.bad_gateway("test")
        |> json_response(:bad_gateway)

      assert response["errors"] == ["test"]
    end

    test "Should return base 502 error" do
      response =
        build_conn()
        |> Response.bad_gateway()
        |> json_response(:bad_gateway)

      assert response == %{
               "errors" => [
                 %{
                   "code" => "bad_gateway",
                   "description" => "Bad Gateway"
                 }
               ]
             }
    end

    test "Should return custom 502 errors" do
      response =
        build_conn()
        |> Response.bad_gateway([
          %{
            code: "bad_gateway",
            description: "This was an error"
          }
        ])
        |> json_response(:bad_gateway)

      assert response == %{
               "errors" => [
                 %{
                   "code" => "bad_gateway",
                   "description" => "This was an error"
                 }
               ]
             }
    end
  end

  describe "service_unavailable" do
    test "Should return 503" do
      response =
        build_conn()
        |> Response.service_unavailable("test")
        |> json_response(:service_unavailable)

      assert response["errors"] == ["test"]
    end

    test "Should return base 503 error" do
      response =
        build_conn()
        |> Response.service_unavailable()
        |> json_response(:service_unavailable)

      assert response == %{
               "errors" => [
                 %{
                   "code" => "service_unavailable",
                   "description" => "Service Unavailable"
                 }
               ]
             }
    end

    test "Should return custom 503 errors" do
      response =
        build_conn()
        |> Response.service_unavailable([
          %{
            code: "service_unavailable",
            description: "This was an error"
          }
        ])
        |> json_response(:service_unavailable)

      assert response == %{
               "errors" => [
                 %{
                   "code" => "service_unavailable",
                   "description" => "This was an error"
                 }
               ]
             }
    end
  end
end
