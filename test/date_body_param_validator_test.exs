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
                   "description" => "failed to parse start_date",
                   "field" => "start_date"
                 }
               ]
             } =
               :post
               |> build_conn("/", start_date: "john")
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
                   "description" => "failed to parse start_at",
                   "field" => "start_at"
                 }
               ]
             } =
               :post
               |> build_conn("/", start_at: "john")
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
                   "description" => "failed to parse end_date",
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
  end
end
