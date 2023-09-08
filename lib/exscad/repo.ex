defmodule Exscad.Repo do
  use Ecto.Repo,
    otp_app: :exscad,
    adapter: Ecto.Adapters.Postgres
end
