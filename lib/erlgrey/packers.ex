defprotocol Erlgrey.Packer32 do
  @spec pack(value :: term) :: binary | iolist
  def pack(value)
end

defimpl Erlgrey.Packer32, for: BitString do
  def pack(value) do
    size = byte_size(value)
    <<"B",size::big-signed-integer-size(32),value::binary>>
  end
end

defimpl Erlgrey.Packer32, for: Integer do
  def pack(value) do
    <<"I",value::big-signed-integer-size(32)>>
  end
end

defimpl Erlgrey.Packer32, for: Float do
  def pack(value) do
    <<"F",value::big-float-size(32)>>
  end
end

defimpl Erlgrey.Packer32, for: List do
  def pack(list) do
    size = length(list)
    [<<"L",size::big-signed-integer-size(32)>>, Enum.map(list, &@protocol.pack/1)]
  end
end

defimpl Erlgrey.Packer32, for: Map do
  def pack(map) do
    size = Enum.count(map)
    [<<"M",size::big-signed-integer-size(32)>>, Enum.map(map, fn {key, value} ->
      [@protocol.pack(key), @protocol.pack(value)]
    end)]
  end
end

defimpl Erlgrey.Packer32, for: Tuple do
  def pack(tuple) do
    size = tuple_size(tuple)
    [<<"U",size::big-signed-integer-size(32)>>, Enum.map(Tuple.to_list(tuple), fn item ->
      @protocol.pack(item)
    end)]
  end
end

defimpl Erlgrey.Packer32, for: Atom do
  def pack(nil) do
    <<"0">>
  end

  def pack(true) do
    <<"T">>
  end

  def pack(false) do
    <<"F">>
  end

  def pack(atom) do
    str = Atom.to_string(atom)
    size = byte_size(str)
    <<"A",size::big-signed-integer-size(32),str::binary>>
  end
end

defprotocol Erlgrey.Packer64 do
  @spec pack(value :: term) :: binary | iolist
  def pack(value)
end

defimpl Erlgrey.Packer64, for: BitString do
  def pack(value) do
    size = byte_size(value)
    <<"B",size::big-signed-integer-size(64),value::binary>>
  end
end

defimpl Erlgrey.Packer64, for: Integer do
  def pack(value) do
    <<"I",value::big-signed-integer-size(64)>>
  end
end

defimpl Erlgrey.Packer64, for: Float do
  def pack(value) do
    <<"F",value::big-float-size(64)>>
  end
end

defimpl Erlgrey.Packer64, for: List do
  def pack(list) do
    size = length(list)
    [<<"L",size::big-signed-integer-size(64)>>, Enum.map(list, &@protocol.pack/1)]
  end
end

defimpl Erlgrey.Packer64, for: Map do
  def pack(map) do
    size = Enum.count(map)
    [<<"M",size::big-signed-integer-size(64)>>, Enum.map(map, fn {key, value} ->
      [@protocol.pack(key), @protocol.pack(value)]
    end)]
  end
end

defimpl Erlgrey.Packer64, for: Tuple do
  def pack(tuple) do
    size = tuple_size(tuple)
    [<<"U",size::big-signed-integer-size(64)>>, Enum.map(Tuple.to_list(tuple), fn item ->
      @protocol.pack(item)
    end)]
  end
end

defimpl Erlgrey.Packer64, for: Atom do
  def pack(nil) do
    <<"0">>
  end

  def pack(true) do
    <<"T">>
  end

  def pack(false) do
    <<"F">>
  end

  def pack(atom) do
    str = Atom.to_string(atom)
    size = byte_size(str)
    <<"A",size::big-signed-integer-size(64),str::binary>>
  end
end
