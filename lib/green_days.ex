defmodule GreenDays do
  @moduledoc """
  Green days is a utility cli that creates empty commits according to the provided cli arguments
  """

  defp check_max_commits(nil), do: {:error, "--max-commits flag is required"}
  defp check_max_commits(commits) when is_integer(commits) and commits > 0, do: :ok
  defp check_max_commits(_), do: {:error, ~c"--max-commits per day should be a positive integer"}

  defp check_skip_weekends(nil), do: {:error, "--skip-weekends flag is required"}
  defp check_skip_weekends(skip_weekends) when is_boolean(skip_weekends), do: :ok
  defp check_skip_weekends(_), do: {:error, ~c"--skip-weekends flag should be boolean"}

  defp check_years(nil), do: {:error, "--years flag is required"}
  defp check_years(years) when is_integer(years) and years > 0, do: :ok
  defp check_years(_), do: {:error, ~c"--years flag should be a positive integer"}

  defp validate_args(max_commits, skip_weekends, years) do
    with :ok <- check_max_commits(max_commits),
         :ok <- check_skip_weekends(skip_weekends),
         :ok <- check_years(years) do
      :ok
    else
      {:error, _} = error -> error
    end
  end

  defp generate_random_millis(), do: :rand.uniform(1001) - 1
  defp generate_random_seconds(), do: :rand.uniform(60) - 1
  defp generate_random_minutes(), do: :rand.uniform(60) - 1
  defp generate_random_hours(), do: :rand.uniform(24) - 1

  defp generate_random_commits_number(max_commits), do: :rand.uniform(max_commits)

  defp generate_random_time() do
    Time.new(
      generate_random_hours(),
      generate_random_minutes(),
      generate_random_seconds(),
      generate_random_millis()
    )
  end

  defp generate_date_time(date) do
    {:ok, time} = generate_random_time()
    {:ok, date_time} = DateTime.new(date, time)
    DateTime.to_iso8601(date_time)
  end

  defp generate_dates_from(years_ago, skip_weekends) do
    days_ago = years_ago * 365
    starting_date = Date.add(Date.utc_today(), -days_ago)

    Enum.to_list(days_ago..1)
    |> Enum.map(fn days -> Date.add(starting_date, days) end)
    |> Enum.filter(fn date ->
      !skip_weekends ||
        (Date.day_of_week(date) != 6 && Date.day_of_week(date) != 7)
    end)
    |> Enum.map(fn date -> generate_date_time(date) end)
  end

  defp generate_commit(date_time) do
    System.cmd("git", [
      "commit",
      "--allow-empty",
      "--date",
      date_time,
      "-m",
      "commited in: #{date_time}"
    ])
  end

  @doc """
  main is the entry point of our cli. There are 3 arguments that are expected:
  i.   --max-commits   (non zero positive integer)
  ii.  --skip-weekends (boolean)
  iii. --years         (non zero positive integer)

  it uses git to create empty commits with date starting from Today - years provided,
  random time, weekends skipped according to the argument provided and 1 to max provided
  commits per day.
  """
  def main(args) do
    {options, _, _} =
      OptionParser.parse(args,
        strict: [max_commits: :integer, skip_weekends: :boolean, years: :integer]
      )

    max_commits = options[:max_commits]
    skip_weekends = options[:skip_weekends]
    years = options[:years]

    case validate_args(max_commits, skip_weekends, years) do
      :ok ->
        generate_dates_from(years, skip_weekends)
        |> Enum.each(fn date ->
          Enum.each(Enum.to_list(1..generate_random_commits_number(max_commits)), fn _ ->
            generate_commit(date)
          end)
        end)
      {:error, error} ->
        IO.puts("Aborting dut to error: #{error}")
    end
  end
end
