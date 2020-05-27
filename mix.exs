defmodule Queue.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :queue,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
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
      source_url: "https://github.com/adam-james/queue"
    ]
  end
end
