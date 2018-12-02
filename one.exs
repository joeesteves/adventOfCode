defmodule One do
  def final_frecuency(file_stream) do
    file_stream
    |> Stream.map(fn line ->
      {integer, _} = Integer.parse(line)
      integer
    end)
    |> Enum.sum()
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
          +1
          +1
          """)

        assert final_frecuency(IO.stream(io,:line)) == 3
      end
    end

  [file_name] ->
    File.stream!(file_name, [], :line)
    |> One.final_frecuency()
    |> IO.inspect(label: "Resultado")
end
