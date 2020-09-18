defmodule Erlgrey.Unpacker.Helpers do
  @moduledoc """
  Some helpers for the unpacking module
  """

  @spec capped_range(integer) :: list | Range.t()
  def capped_range(0) do
    # seems weird to use an empty list doesn't it?
    # this is the only enumerable off the top of my head that I can use to effectively give a
    # true 0 element range
    []
  end

  def capped_range(x) do
    # otherwise construct the range like normal
    1..x
  end
end

defmodule Erlgrey.Unpacker32 do
  @moduledoc """
  Unpacking module for 32bit based packed data.

  This module assumes that all integers are 32 bits in length.
  """
  import Erlgrey.Unpacker.Helpers

  def unpack(<<"B",size::big-signed-integer-size(32),str::binary-size(size),rest::binary>>) do
    {:ok, str, rest}
  end

  def unpack(<<"I",value::big-signed-integer-size(32),rest::binary>>) do
    {:ok, value, rest}
  end

  def unpack(<<"F",value::big-float-size(32),rest::binary>>) do
    {:ok, value, rest}
  end

  def unpack(<<"L",0::big-signed-integer-size(32),rest::binary>>) do
    {:ok, [], rest}
  end

  def unpack(<<"L",size::big-signed-integer-size(32),rest::binary>>) do
    {list, rest} =
      Enum.reduce(capped_range(size), {[], rest}, fn _, {acc, rest} ->
        case unpack(rest) do
          {:ok, value, rest} ->
            {[value | acc], rest}
        end
      end)

    {:ok, Enum.reverse(list), rest}
  end

  def unpack(<<"M",0::big-signed-integer-size(32),rest::binary>>) do
    {:ok, %{}, rest}
  end

  def unpack(<<"M",size::big-signed-integer-size(32),rest::binary>>) do
    {list, rest} =
      Enum.reduce(capped_range(size), {[], rest}, fn _, {acc, rest} ->
        with {:ok, key, rest} <- unpack(rest),
             {:ok, value, rest} <- unpack(rest) do
          {[{key, value} | acc], rest}
        end
      end)

    {:ok, Enum.into(list, %{}), rest}
  end

  def unpack(<<"U",0::big-signed-integer-size(32),rest::binary>>) do
    {:ok, {}, rest}
  end

  def unpack(<<"U",size::big-signed-integer-size(32),rest::binary>>) do
    {list, rest} =
      Enum.reduce(capped_range(size), {[], rest}, fn _, {acc, rest} ->
        case unpack(rest) do
          {:ok, value, rest} ->
            {[value | acc], rest}
        end
      end)

    {:ok, List.to_tuple(Enum.reverse(list)), rest}
  end

  def unpack(<<"0",rest::binary>>) do
    {:ok, nil, rest}
  end

  def unpack(<<"T",rest::binary>>) do
    {:ok, true, rest}
  end

  def unpack(<<"F",rest::binary>>) do
    {:ok, false, rest}
  end

  def unpack(<<"A",size::big-signed-integer-size(32),str::binary-size(size),rest::binary>>) do
    {:ok, String.to_existing_atom(str), rest}
  end
end

defmodule Erlgrey.Unpacker64 do
  @moduledoc """
  Unpacking module for 32bit based packed data.

  This module assumes that all integers are 64 bits in length.
  """
  import Erlgrey.Unpacker.Helpers

  def unpack(<<"B",size::big-signed-integer-size(64),str::binary-size(size),rest::binary>>) do
    {:ok, str, rest}
  end

  def unpack(<<"I",value::big-signed-integer-size(64),rest::binary>>) do
    {:ok, value, rest}
  end

  def unpack(<<"F",value::big-float-size(64),rest::binary>>) do
    {:ok, value, rest}
  end

  def unpack(<<"L",0::big-signed-integer-size(64),rest::binary>>) do
    # optimization for empty lists
    {:ok, [], rest}
  end

  def unpack(<<"L",size::big-signed-integer-size(64),rest::binary>>) do
    {list, rest} =
      Enum.reduce(capped_range(size), {[], rest}, fn _, {acc, rest} ->
        case unpack(rest) do
          {:ok, value, rest} ->
            {[value | acc], rest}
        end
      end)

    {:ok, Enum.reverse(list), rest}
  end

  def unpack(<<"M",0::big-signed-integer-size(64),rest::binary>>) do
    {:ok, %{}, rest}
  end

  def unpack(<<"M",size::big-signed-integer-size(64),rest::binary>>) do
    {list, rest} =
      Enum.reduce(capped_range(size), {[], rest}, fn _, {acc, rest} ->
        with {:ok, key, rest} <- unpack(rest),
             {:ok, value, rest} <- unpack(rest) do
          {[{key, value} | acc], rest}
        end
      end)

    {:ok, Enum.into(list, %{}), rest}
  end

  def unpack(<<"U",0::big-signed-integer-size(64),rest::binary>>) do
    {:ok, {}, rest}
  end

  def unpack(<<"U",size::big-signed-integer-size(64),rest::binary>>) do
    {list, rest} =
      Enum.reduce(capped_range(size), {[], rest}, fn _, {acc, rest} ->
        case unpack(rest) do
          {:ok, value, rest} ->
            {[value | acc], rest}
        end
      end)

    {:ok, List.to_tuple(Enum.reverse(list)), rest}
  end

  def unpack(<<"0",rest::binary>>) do
    {:ok, nil, rest}
  end

  def unpack(<<"T",rest::binary>>) do
    {:ok, true, rest}
  end

  def unpack(<<"F",rest::binary>>) do
    {:ok, false, rest}
  end

  def unpack(<<"A",size::big-signed-integer-size(64),str::binary-size(size),rest::binary>>) do
    {:ok, String.to_existing_atom(str), rest}
  end
end
