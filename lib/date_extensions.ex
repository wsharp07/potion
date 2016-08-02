defmodule DateExtensions do
  use Timex

  defimpl Phoenix.HTML.Safe, for: [Timex.DateTime, Timex.Ecto.DateTime] do
    def to_iodata(t) do
      Timex.format!(t, "%A, %B %e %Y @ %l:%m%p", :strftime)
    end
  end

  def format_date(input) do
    input
      |> Timex.local
      |> Timex.format!( "%A, %B %e %Y @ %l:%m%p", :strftime)
  end
end
