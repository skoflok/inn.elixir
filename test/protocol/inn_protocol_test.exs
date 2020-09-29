defmodule InnProtocolTest do
  alias InnProtocol

  use ExUnit.Case

  @valid_inn 500_100_732_259
  @invalid_inn 500_100_732_258

  test "validate true" do
    assert true == InnProtocol.validate(@valid_inn)
  end

  test "validate false" do
    assert false == InnProtocol.validate(@invalid_inn)
  end
end
