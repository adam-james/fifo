defmodule FIFO.MixProject do
  use Mix.Project

  @version "0.1.0"
  @description "A first-in-first-out queue data structure for Elixir."

  def project do
    [
      app: :fifo,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      description: @description,
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    %{
      licenses: ["Apache-2.0"],
      maintainers: ["Adam Sulewski"],
      links: %{"GitHub" => "https://github.com/adam-james/fifo"},
      files: ["lib", "mix.exs", "README.md", "bench", ".formatter.exs"]
    }
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:benchee, "~> 1.0", only: :dev}
    ]
  end

  defp docs do
    [
      extras: [
        "README.md"
      ],
      main: "readme",
      source_ref: "v#{@version}",
      source_url: "https://github.com/adam-james/fifo"
    ]
  end
end
