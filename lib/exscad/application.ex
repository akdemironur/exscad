defmodule Exscad.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ExscadWeb.Telemetry,
      # Start the Ecto repository
      Exscad.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Exscad.PubSub},
      # Start Finch
      {Finch, name: Exscad.Finch},
      # Start the Endpoint (http/https)
      ExscadWeb.Endpoint
      # Start a worker by calling: Exscad.Worker.start_link(arg)
      # {Exscad.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Exscad.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExscadWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
