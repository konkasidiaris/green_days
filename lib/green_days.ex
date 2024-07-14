defmodule GreenDays do
  @moduledoc """
  Green days is a utility cli that creates empty commits according to the provided cli arguments
  """

  defp validate_args(max_commits, skip_weekends, years) do
    with :ok <- Validator.check_max_commits(max_commits),
         :ok <- Validator.check_skip_weekends(skip_weekends),
         :ok <- Validator.check_years(years) do
      :ok
    else
      {:error, _} = error -> error
    end
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
        Generator.generate_dates_from(Date.utc_today(), years, skip_weekends)
        |> Enum.each(fn date ->
          Enum.each(
            Enum.to_list(1..Generator.generate_random_commits_number(max_commits)),
            fn _ ->
              System.cmd("git", Generator.generate_arguments(date))
            end
          )
        end)

      {:error, error} ->
        IO.puts("Aborting dut to error: #{error}")
    end
  end
end
