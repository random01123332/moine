defmodule Mwoine.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MwoineWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:mwoine, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Mwoine.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Mwoine.Finch},
      # Start a worker by calling: Mwoine.Worker.start_link(arg)
      # {Mwoine.Worker, arg},
      # Start to serve requests, typically the last entry
      MwoineWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mwoine.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MwoineWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
