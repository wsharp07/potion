defmodule Potion.Mixfile do
  use Mix.Project

  def project do
    [app: :potion,
     version: "0.0.3",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
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
    [{:phoenix, "~> 1.2"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, "~> 0.11"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:comeonin, "~> 2.3"},
     {:conform, "~> 0.17"},
     {:ex_machina, "~> 1.0"},
     {:earmark, "~> 1.0"},
     {:phoenix_calendar, "~> 0.1"},
     {:timex, "~>3.0"},
     {:timex_ecto, "~>3.0"},
     {:exrm, "~> 1.0"}]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]
  ]
  end

  # define environment applications
  defp app_list(:test), do: [:ex_machina | app_list]
  defp app_list(_), do: app_list
  defp app_list, do: [:phoenix, :phoenix_html, :cowboy, :logger,
    :gettext, :phoenix_ecto, :postgrex, :comeonin, :tzdata, :timex_ecto, :phoenix_calendar,
    :ex_machina, :earmark, :neotoma, :conform, :phoenix_pubsub]
end
