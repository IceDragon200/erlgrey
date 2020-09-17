defmodule ErlgreyTest do
  use ExUnit.Case

  describe "(un)pack32/2" do
    test "can (un)pack a binary" do
      result = Erlgrey.pack32("Hello, World", return: :binary)
      assert <<"B",12::signed-big-integer-size(32),"Hello, World">> == result
      assert {:ok, "Hello, World", ""} == Erlgrey.unpack32(result)
    end

    test "can (un)pack an integer" do
      for x <- [-2147483648, -1, 0, 1, 2147483647] do
        result = Erlgrey.pack32(x, return: :binary)
        assert <<"I",x::signed-big-integer-size(32)>> == result
        assert {:ok, x, ""} == Erlgrey.unpack32(result)
      end
    end

    test "can (un)pack a float" do
      for x <- [-7643.946, -1.3, 0.0, 1.3, 4678.632] do
        result = Erlgrey.pack32(x, return: :binary)
        assert <<"F",x::big-float-size(32)>> == result
        assert {:ok, y, ""} = Erlgrey.unpack32(result)
        # fuzzy match
        assert Float.round(x, 2) == Float.round(y, 2)
      end
    end

    test "can (un)pack an empty list" do
      x = []
      result = Erlgrey.pack32(x, return: :binary)
      assert <<"L",0::signed-big-integer-size(32)>> == result
      assert {:ok, x, ""} == Erlgrey.unpack32(result)
    end

    test "can (un)pack a list" do
      x = ["Hello",1,12.43,[],%{}]
      result = Erlgrey.pack32(x, return: :binary)
      assert <<"L",5::signed-big-integer-size(32),_rest::binary>> = result
      assert {:ok, ["Hello",1,f,[],%{}], ""} = Erlgrey.unpack32(result)
      assert Float.round(f, 2) == Float.round(12.43, 2)
    end

    test "can (un)pack a map" do
      x = %{1 => "Hello", "world" => "Dah", 2 => ["a"]}
      result = Erlgrey.pack32(x, return: :binary)
      assert <<"M",3::signed-big-integer-size(32),_rest::binary>> = result
      assert {:ok, %{1 => "Hello", "world" => "Dah", 2 => ["a"]}, ""} = Erlgrey.unpack32(result)
    end

    test "can (un)pack a nil value" do
      result = Erlgrey.pack32(nil, return: :binary)
      assert <<"0">> = result
      assert {:ok, nil, ""} = Erlgrey.unpack32(result)
    end

    test "can (un)pack a true value" do
      result = Erlgrey.pack32(true, return: :binary)
      assert <<"T">> = result
      assert {:ok, true, ""} = Erlgrey.unpack32(result)
    end

    test "can (un)pack a false value" do
      result = Erlgrey.pack32(false, return: :binary)
      assert <<"F">> = result
      assert {:ok, false, ""} = Erlgrey.unpack32(result)
    end

    test "can (un)pack an atom value" do
      result = Erlgrey.pack32(:binary, return: :binary)
      assert <<"A",6::signed-big-integer-size(32),_rest::binary>> = result
      assert {:ok, :binary, ""} = Erlgrey.unpack32(result)
    end
  end
end
