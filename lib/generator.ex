defmodule Generator do
  @moduledoc """
  Handles date, time and commit message generation
  """
  defp generate_random_millis(), do: :rand.uniform(1001) - 1
  defp generate_random_seconds(), do: :rand.uniform(60) - 1
  defp generate_random_minutes(), do: :rand.uniform(60) - 1
  defp generate_random_hours(), do: :rand.uniform(24) - 1

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

  def generate_random_commits_number(max_commits), do: :rand.uniform(max_commits)

  def generate_dates_from(today, years_ago, skip_weekends) do
    days_ago = years_ago * 365
    starting_date = Date.add(today, -days_ago)

    Enum.to_list(days_ago..1)
    |> Enum.map(fn days -> Date.add(starting_date, days) end)
    |> Enum.filter(fn date ->
      !skip_weekends ||
        (Date.day_of_week(date) != 6 && Date.day_of_week(date) != 7)
    end)
    |> Enum.map(fn date -> generate_date_time(date) end)
  end

  def generate_arguments(date_time) do
    [
      "commit",
      "--allow-empty",
      "--date",
      date_time,
      "-m",
      "commited in: #{date_time}"
    ]
  end
end
