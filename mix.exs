defmodule ISO8583.MixProject do
  use Mix.Project

  def project do
    [
      app: :iso_8583,
      version: "0.1.1",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description()
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, "~> 0.19"},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "An Elixir module collection for ISO 8583 massing."
  end

  defp package() do
    [
      name: "iso_8583",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Danstan Onyango"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/zemuldo/iso_8583_elixir"},
      source_url: "https://github.com/zemuldo/iso_8583_elixir"
    ]
  end
end
