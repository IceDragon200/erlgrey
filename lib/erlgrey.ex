defmodule Erlgrey do
  @moduledoc """
  Erlgrey is an erlang term packer, it aims to support all of the portable types, this includes:

  * Tuples
  * Lists
  * Maps
  * Atoms (some have specialized values)
  * Binaries
  * Integers
  * Floats
  """

  @spec pack32(term, Keyword.t()) :: iodata
  def pack32(value, options \\ []) do
    result = Erlgrey.Packer32.pack(value)

    handle_pack(result, options)
  end

  @spec pack64(term, Keyword.t()) :: iodata
  def pack64(value, options \\ []) do
    result = Erlgrey.Packer64.pack(value)

    handle_pack(result, options)
  end

  def unpack32(value) when is_binary(value) do
    Erlgrey.Unpacker32.unpack(value)
  end

  def unpack64(value) when is_binary(value) do
    Erlgrey.Unpacker64.unpack(value)
  end

  defp handle_pack(value, options) do
    case Keyword.get(options, :return, :iodata) do
      :iodata ->
        value

      :binary ->
        IO.iodata_to_binary(value)
    end
  end
end
