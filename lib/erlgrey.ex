defmodule Erlgrey.UnpackError do
  defexception [:message]
end

defmodule Erlgrey do
  @moduledoc """
  Erlgrey is an erlang term packer, it aims to support all of the portable types, this includes:

  * Tuples
  * Lists
  * Maps
  * Atoms (includes nil, true and false as specialized values)
  * Binaries
  * Integers
  * Floats
  """

  @typedoc """
  Determines what kind of data is returned by packing functions

  It can either be the raw :iodata or a flattened :binary
  """
  @type return_type :: :iodata | :binary

  @type pack_option :: {:return, return_type}

  @doc """
  Packs the given term as an erlgrey binary
  """
  @spec pack32(term, [pack_option]) :: iodata
  def pack32(value, options \\ []) do
    result = Erlgrey.Packer32.pack(value)

    handle_pack(result, options)
  end

  @spec pack64(term, [pack_option]) :: iodata
  def pack64(value, options \\ []) do
    result = Erlgrey.Packer64.pack(value)

    handle_pack(result, options)
  end

  def unpack32(value) when is_binary(value) do
    Erlgrey.Unpacker32.unpack(value)
  end

  def unpack32!(value) when is_binary(value) do
    case unpack32(value) do
      {:ok, value, _rest} ->
        value

      {:error, _reason} ->
        raise Erlgrey.UnpackError
    end
  end

  def unpack64(value) when is_binary(value) do
    Erlgrey.Unpacker64.unpack(value)
  end

  def unpack64!(value) when is_binary(value) do
    case unpack64(value) do
      {:ok, value, _rest} ->
        value

      {:error, _reason} ->
        raise Erlgrey.UnpackError
    end
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
