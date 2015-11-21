defmodule DateExtensions do
  def format_date(input) do
    input |> Calendar.Strftime.strftime!("%A, %B %e %Y @ %l:%m%p")
  end
end
