defmodule One do
  def repeated_frecuency(file_stream) do
    file_stream
    |> Stream.cycle()
    |> Stream.map(fn line ->
      {integer, _} = Integer.parse(line)
      integer
    end)
    |> Enum.reduce_while({0, MapSet.new([0])}, fn x, {last_freq, seen_freqs} ->
      curr_freq = last_freq + x

      if curr_freq in seen_freqs do
        {:halt, curr_freq}
      else
        {:cont, {curr_freq, MapSet.put(seen_freqs, curr_freq)}}
      end
    end)
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule TestOne do
      use ExUnit.Case

      import One

      test "final_frecuency" do
        {:ok, io} =
          StringIO.open("""
          +1
          -2
          +3
          +1
          +1
          -2
          """)

        assert repeated_frecuency(IO.stream(io, :line)) == 2
      end
    end

  [file_name] ->
    File.stream!(file_name, [], :line)
    |> One.repeated_frecuency()
    |> IO.inspect(label: "Resultado")
end
