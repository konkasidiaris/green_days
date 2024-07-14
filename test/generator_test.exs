defmodule GeneratorTest do
  use ExUnit.Case

  describe "dates list generation" do
    test "1 year worth of dates without weekends" do
      date_list = Generator.generate_dates_from(1, true)
      assert length(date_list) == 52 * 5
    end

    test "1 year worth of dates with weekends" do
      date_list = Generator.generate_dates_from(1, false)
      assert length(date_list) == 365
    end
  end

  describe "git arguments list generation" do
    test "adds datetime in the correct position" do
      date_time = DateTime.to_iso8601(~U[2022-01-12 00:01:00.00Z])
      assert Generator.generate_arguments(date_time) == [
        "commit",
        "--allow-empty",
        "--date",
        "2022-01-12T00:01:00.00Z",
        "-m",
        "commited in: 2022-01-12T00:01:00.00Z",
      ]
    end
  end
end
