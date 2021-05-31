defmodule Solicit.Plugs.Validation.PaginationParamssTest do
  use ExUnit.Case, async: true

  import Phoenix.ConnTest
  alias Solicit.Plugs.Validation.PaginationParams

  describe "call" do
    dataprovider = [
      %{
        test_scenario: "offset and page provided, expect error",
        value: "?offset=1&page=1",
        expectation: :unprocessable_entity
      },
      %{
        test_scenario: "offset provided not a number, expect error",
        value: "?offset=abc123",
        expectation: :unprocessable_entity
      },
      %{
        test_scenario: "page provided not a number, expect error",
        value: "?page=abc123",
        expectation: :unprocessable_entity
      },
      %{
        test_scenario: "offset provided but empty, expect error",
        value: "?offset=",
        expectation: :unprocessable_entity
      },
      %{
        test_scenario: "page provided but empty, expect error",
        value: "?page=",
        expectation: :unprocessable_entity
      },
      %{
        test_scenario: "offset provided but negative number, expect error",
        value: "?offset=-1",
        expectation: :unprocessable_entity
      },
      %{
        test_scenario: "page provided but negative number, expect error",
        value: "?page=-1",
        expectation: :unprocessable_entity
      }
    ]

    Enum.each(dataprovider, fn %{
                                 test_scenario: test_scenario,
                                 value: value,
                                 expectation: expectation
                               } ->
      @test_scenario test_scenario
      @value value
      @expectation expectation
      test "#{@test_scenario}" do
        build_conn(:get, @value)
        |> Plug.Conn.fetch_query_params()
        |> PaginationParams.call([])
        |> json_response(@expectation)
      end
    end)

    dataprovider = [
      %{
        test_scenario: "limit provided not a number returns default limit",
        value: "?limit=abc123",
        expectation: %{params: %{"limit" => 1000}}
      },
      %{
        test_scenario: "limit provided but empty returns default limit",
        value: "?limit=",
        expectation: %{params: %{"limit" => 1000}}
      },
      %{
        test_scenario: "limit provided but negative number returns default limit",
        value: "?limit=-1",
        expectation: %{params: %{"limit" => 1000}}
      },
      %{
        test_scenario: "limit exceeds default limit ceiling returns default limit",
        value: "?limit=999999",
        expectation: %{params: %{"limit" => 1000}}
      }
    ]

    Enum.each(dataprovider, fn %{
                                 test_scenario: test_scenario,
                                 value: value,
                                 expectation: expectation
                               } ->
      @test_scenario test_scenario
      @value value
      @expectation expectation
      test "#{@test_scenario}" do
        @expectation =
          build_conn(:get, @value)
          |> Plug.Conn.fetch_query_params()
          |> PaginationParams.call([])
      end
    end)

    test "limit exceeds custom limit returns custom limit" do
      %{params: %{"limit" => 10}} =
        build_conn(:get, "?limit=11")
        |> Plug.Conn.fetch_query_params()
        |> PaginationParams.call(max_limit: 10)
    end

    dataprovider = [
      %{
        test_scenario: "offset provided",
        value: "?offset=1"
      },
      %{
        test_scenario: "page provided",
        value: "?page=1"
      },
      %{
        test_scenario: "offset and limit provided",
        value: "?offset=1&limit=1"
      },
      %{
        test_scenario: "page and limit provided",
        value: "?page=1&limit=1"
      },
    ]

    Enum.each(dataprovider, fn %{
                                 test_scenario: test_scenario,
                                 value: value
                               } ->
      @test_scenario test_scenario
      @value value
      test "#{@test_scenario}" do
        conn = Plug.Conn.fetch_query_params(build_conn(:get, @value))
        assert conn == PaginationParams.call(conn, [])
      end
    end)
  end
end
