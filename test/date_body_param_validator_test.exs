defmodule Solicit.Plugs.Validation.DateBodyParamsTest do
  use ExUnit.Case, async: true

  import Phoenix.ConnTest
  alias Solicit.Plugs.Validation.DateBodyParams

  describe "call" do
    test "invalid start_date format, expect error" do
      assert %{
               "errors" => [
                 %{
                   "code" => "unprocessable_entity",
                   "description" => "failed to parse start date",
                   "field" => "start_date"
                 }
               ]
             } =
               :post
               |> build_conn("/", start_date: "john")
               |> DateBodyParams.call([])
               |> json_response(:unprocessable_entity)
    end

    test "invalid start_date format given end_date, expect error" do
      assert %{
               "errors" => [
                 %{
                   "code" => "unprocessable_entity",
                   "description" => "failed to parse start date",
                   "field" => "start_date"
                 }
               ]
             } =
               :post
               |> build_conn("/", start_date: "john", end_date: "2021-08-03T00:00:00.000Z")
               |> DateBodyParams.call([])
               |> json_response(:unprocessable_entity)
    end

    test "invalid end_date format, expect error" do
      assert %{
               "errors" => [
                 %{
                   "code" => "unprocessable_entity",
                   "description" => "failed to parse end date",
                   "field" => "end_date"
                 }
               ]
             } =
               :post
               |> build_conn("/", start_date: "2021-08-03T00:00:00.000Z", end_date: "john")
               |> DateBodyParams.call([])
               |> json_response(:unprocessable_entity)
    end

    test "end_date but no start_date, expect error" do
      assert %{
               "errors" => [
                 %{
                   "code" => "unprocessable_entity",
                   "description" => "start_date must be set if end_date is set",
                   "field" => "start_date"
                 }
               ]
             } =
               :post
               |> build_conn("/", end_date: "john")
               |> DateBodyParams.call([])
               |> json_response(:unprocessable_entity)
    end

    test "invalid start_at format, expect error" do
      assert %{
               "errors" => [
                 %{
                   "code" => "unprocessable_entity",
                   "description" => "failed to parse start date",
                   "field" => "start_at"
                 }
               ]
             } =
               :post
               |> build_conn("/", start_at: "john")
               |> DateBodyParams.call([])
               |> json_response(:unprocessable_entity)
    end

    test "invalid start_at format given end_at, expect error" do
      assert %{
               "errors" => [
                 %{
                   "code" => "unprocessable_entity",
                   "description" => "failed to parse start date",
                   "field" => "start_at"
                 }
               ]
             } =
               :post
               |> build_conn("/", start_at: "john", end_at: "2021-08-03T00:00:00.000Z")
               |> DateBodyParams.call([])
               |> json_response(:unprocessable_entity)
    end

    test "invalid end_at format, expect error" do
      assert %{
               "errors" => [
                 %{
                   "code" => "unprocessable_entity",
                   "description" => "failed to parse end date",
                   "field" => "end_at"
                 }
               ]
             } =
               :post
               |> build_conn("/", start_at: "2021-08-03T00:00:00.000Z", end_at: "john")
               |> DateBodyParams.call([])
               |> json_response(:unprocessable_entity)
    end

    test "end_at but no start_date, expect error" do
      assert %{
               "errors" => [
                 %{
                   "code" => "unprocessable_entity",
                   "description" => "start_at must be set if end_at is set",
                   "field" => "start_at"
                 }
               ]
             } =
               :post
               |> build_conn("/", end_at: "john")
               |> DateBodyParams.call([])
               |> json_response(:unprocessable_entity)
    end

    test "start_date is valid but invalid end_date, expect error" do
      assert %{
               "errors" => [
                 %{
                   "code" => "unprocessable_entity",
                   "description" => "failed to parse end date",
                   "field" => "end_date"
                 }
               ]
             } =
               :post
               |> build_conn("/", start_date: "2021-08-03T00:00:00.000Z", end_date: "john")
               |> DateBodyParams.call([])
               |> json_response(:unprocessable_entity)
    end

    test "start_date is valid" do
      assert %Plug.Conn{} =
               :post
               |> build_conn("/", start_date: "2021-08-03T00:00:00.000Z")
               |> DateBodyParams.call([])
    end

    test "start_at is valid" do
      assert %Plug.Conn{} =
               :post
               |> build_conn("/", start_at: "2021-08-03T00:00:00.000Z")
               |> DateBodyParams.call([])
    end

    test "end_date is before now, expect error" do
      assert %{
               "errors" => [
                 %{
                   "code" => "unprocessable_entity",
                   "description" => "end date must be in the future",
                   "field" => "end_date"
                 }
               ]
             } =
               :post
               |> build_conn("/",
                 start_date: "2021-08-02T00:00:00.000Z",
                 end_date: "2021-08-03T00:00:00.000Z"
               )
               |> DateBodyParams.call([])
               |> json_response(:unprocessable_entity)
    end

    test "end_at is before now, expect error" do
      assert %{
               "errors" => [
                 %{
                   "code" => "unprocessable_entity",
                   "description" => "end date must be in the future",
                   "field" => "end_at"
                 }
               ]
             } =
               :post
               |> build_conn("/",
                 start_at: "2021-08-02T00:00:00.000Z",
                 end_at: "2021-08-03T00:00:00.000Z"
               )
               |> DateBodyParams.call([])
               |> json_response(:unprocessable_entity)
    end

    test "start_date after end_date, expect error" do
      assert %{
               "errors" => [
                 %{
                   "code" => "unprocessable_entity",
                   "description" => "start date must be before end date",
                   "field" => "start_date"
                 }
               ]
             } =
               :post
               |> build_conn("/",
                 start_date: "2021-08-03T00:00:00.000Z",
                 end_date: "2021-08-02T00:00:00.000Z"
               )
               |> DateBodyParams.call([])
               |> json_response(:unprocessable_entity)
    end

    test "start_at after end_at, expect error" do
      assert %{
               "errors" => [
                 %{
                   "code" => "unprocessable_entity",
                   "description" => "start date must be before end date",
                   "field" => "start_at"
                 }
               ]
             } =
               :post
               |> build_conn("/",
                    start_at: "2021-08-03T00:00:00.000Z",
                    end_at: "2021-08-02T00:00:00.000Z"
                  )
               |> DateBodyParams.call([])
               |> json_response(:unprocessable_entity)
    end
  end
end
