defmodule Potion.Mixfile do
  use Mix.Project

  def project do
    [app: :potion,
     version: "0.0.3",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Potion, []},
     applications: app_list(Mix.env)]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.1.4"},
     {:phoenix_ecto, "~> 2.0"},
     {:postgrex, ">= 0.7.0"},
     {:phoenix_html, "~> 2.3"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.9"},
     {:cowboy, "~> 1.0"},
     {:comeonin, "~> 2.1"},
     {:exrm, "~> 0.19.9"},
     {:conform, "~> 0.17"},
     {:ex_machina, "~> 0.6"},
     {:earmark, "~> 0.2.1"},
     {:phoenix_calendar, "~> 0.1"},
     {:timex, "~>1.0"},
     {:timex_ecto, "~>0.1"},
     {:exrm, "~> 0.19"}]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end

  # define environment applications
  defp app_list(:test), do: [:ex_machina | app_list]
  defp app_list(_), do: app_list
  defp app_list, do: [:phoenix, :phoenix_html, :cowboy, :logger,
    :gettext, :phoenix_ecto, :postgrex, :comeonin, :tzdata]
end
