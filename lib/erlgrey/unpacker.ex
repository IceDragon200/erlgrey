defmodule Erlgrey.Unpacker.Helpers do
  def capped_range(0) do
    []
  end

  def capped_range(x) do
    1..x
  end
end

defmodule Erlgrey.Unpacker32 do
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
