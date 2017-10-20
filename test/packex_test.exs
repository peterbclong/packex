defmodule PackexTest do
  use ExUnit.Case
  doctest Packex

  test "greets the world" do
    assert Packex.hello() == :world
  end
end
