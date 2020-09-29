defmodule Inn.RedisClientTest do
  alias Inn.RedisClient

  use ExUnit.Case

  describe "banned" do
    @valid_attrs %{:ip => "193.123.130.233", :time => 2000}

    setup do
      on_exit(fn ->
        Redix.command(:redix, ["ZREMRANGEBYSCORE", "banned", "-inf", "+inf"])
      end)
    end

    def ban_fixture(attrs \\ %{}) do
      RedisClient.set_banned(attrs.ip, attrs.time)
    end

    test "set_banned/2 set ban" do
      assert RedisClient.set_banned(@valid_attrs.ip, @valid_attrs.time) == {:ok, 1}
    end

    test "check_banned/1 success ban" do
      ban_fixture(@valid_attrs)
      result = RedisClient.check_banned(@valid_attrs.ip)
      {success, _score} = result
      assert true === success
    end
  end
end
