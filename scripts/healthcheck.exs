{result, _} = System.cmd("docker", ["ps"])
  
result
  |> String.split("  ")
  |> Enum.filter(&(&1 =~ "health" || &1 =~ "tcp"))
  |> Enum.join("\n")
  |> IO.puts
