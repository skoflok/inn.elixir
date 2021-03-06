defmodule InnWeb.PublicChannelTest do
  use InnWeb.ChannelCase

  alias Inn.RedisClient

  @ip {1, 2, 3, 4}


  setup do
    {:ok, _, socket} =
      InnWeb.UserSocket
      |> socket("user_id", %{peer_data: %{address: @ip}})
      |> subscribe_and_join(InnWeb.PublicChannel, "public:checker")

    on_exit(fn ->
      Redix.command(:redix, ["ZREMRANGEBYSCORE", "banned", "-inf", "+inf"])
    end)

    %{socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push(socket, "ping", %{"hello" => "there"})
    assert_reply(ref, :ok, %{"hello" => "there"})
  end

  test "shout broadcasts to public:checker", %{socket: socket} do
    push(socket, "shout", %{"hello" => "all"})
    assert_broadcast("shout", %{"hello" => "all"})
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push("broadcast", %{"some" => "data"})
  end

  test "validate message ok", %{socket: socket} do
    push(socket, "validation", %{"body" => %{"number" => "123213"}})
    assert_broadcast("validation", %{:data => _, :body => _, :status => true})
  end

end
