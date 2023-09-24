defmodule C do
  def start, do: spawn(fn -> loop(0) end)

  def add(spid, v), do: send(spid, {:add, v})
  def sub(spid, v), do: send(spid, {:sub, v})
  def mul(spid, v), do: send(spid, {:mul, v})
  def div(spid, v), do: send(spid, {:div, v})
  def get(spid) do 
    send(spid, {:val, self()})
    receive do
      {:response, v} -> v
      after 4000 -> "No response from server"
    end
    
  end

  defp loop(value) do
    new_value = receive do
      message ->
        update(value, message)
    end
    loop(new_value) 
  end

  defp update(value, {:add, v}), do: value + v
  defp update(value, {:sub, v}), do: value - v
  defp update(value, {:mul, v}), do: value * v
  defp update(value, {:div, v}), do: value / v
  defp update(value, {:val, s}) do
    send(s, {:response, value})
    value
  end
  defp update(value, _) do
    IO.puts "Invalid operator"
    value
  end

end
