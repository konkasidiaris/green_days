defmodule ValidatorTest do
  use ExUnit.Case

  describe "validates --max-commits flag" do
    test "returns :error on nil" do
      {:error, message} = Validator.check_max_commits(nil)
      assert message == "--max-commits flag is required"
    end

    for {name, param} <- %{
          "string" => "String",
          "empty string" => "",
          "boolean" => true,
          "floating point number" => 1.2,
          "negative number" => -1,
          "zero" => 0,
          "number expressed as string" => "1"
        } do
      @tag param: param
      test "returns :error on #{name}", %{param: param} do
        {:error, message} = Validator.check_max_commits(param)
        assert message == "--max-commits per day should be a positive integer"
      end
    end

    test "returns :ok on positive integer" do
      assert Validator.check_max_commits(42) == :ok
    end
  end

  describe "validates --skip-weekends flag" do
    test "returns :error on nil" do
      {:error, message} = Validator.check_skip_weekends(nil)
      assert message == "--skip-weekends flag is required"
    end

    for {name, param} <- %{
          "string" => "String",
          "empty string" => "",
          "floating point number" => 1.2,
          "negative number" => -1,
          "zero" => 0
        } do
      @tag param: param
      test "returns :error on #{name}", %{param: param} do
        {:error, message} = Validator.check_skip_weekends(param)
        assert message == "--skip-weekends flag should be boolean"
      end
    end

    for {name, param} <- %{
          "true" => true,
          "false" => false
        } do
      @tag param: param
      test "returns :ok on boolean #{name}", %{param: param} do
        assert Validator.check_skip_weekends(param) == :ok
      end
    end
  end

  describe "validates --years flag" do
    test "returns :error on nil" do
      {:error, message} = Validator.check_years(nil)
      assert message == "--years flag is required"
    end

    for {name, param} <- %{
          "string" => "String",
          "empty string" => "",
          "boolean" => true,
          "floating point number" => 1.2,
          "negative number" => -1,
          "zero" => 0,
          "number expressed as string" => "1"
        } do
      @tag param: param
      test "returns :error on #{name}", %{param: param} do
        {:error, message} = Validator.check_years(param)
        assert message == "--years flag should be a positive integer"
      end
    end

    test "returns :ok on positive integer" do
      assert Validator.check_years(42) == :ok
    end
  end
end
