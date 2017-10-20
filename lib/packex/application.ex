defmodule Packex.Application do
  use Application

  @moduledoc false

  def start(_type, _args) do
    Packex.Supervisor.start_link(nil)
  end
end
