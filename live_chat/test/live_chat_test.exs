defmodule LiveChatTest do
  use ExUnit.Case
  doctest LiveChat

  test "greets the world" do
    assert LiveChat.hello() == :world
  end
end
