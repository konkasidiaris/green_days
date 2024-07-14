defmodule Validator do
  @moduledoc """
  Contains the validators for the cli arguments
  """

  def check_max_commits(nil), do: {:error, "--max-commits flag is required"}
  def check_max_commits(commits) when is_integer(commits) and commits > 0, do: :ok
  def check_max_commits(_), do: {:error, "--max-commits per day should be a positive integer"}

  def check_skip_weekends(nil), do: {:error, "--skip-weekends flag is required"}
  def check_skip_weekends(skip_weekends) when is_boolean(skip_weekends), do: :ok
  def check_skip_weekends(_), do: {:error, "--skip-weekends flag should be boolean"}

  def check_years(nil), do: {:error, "--years flag is required"}
  def check_years(years) when is_integer(years) and years > 0, do: :ok
  def check_years(_), do: {:error, "--years flag should be a positive integer"}
end
