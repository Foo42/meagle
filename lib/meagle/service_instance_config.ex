defmodule Meagle.Config do
	def all do
		from_file
	end

	def from_file do
		config_dir = get_env("CONFIG_DIR", ".")

		config_path = Path.join([config_dir, "monitoringTargets.json"])
		
		config_path
			|> File.read!
			|> Poison.Parser.parse!
 	end

 	defp get_env(name, default \\ nil) do
 		System.get_env 
			|> Enum.map(fn {k,v} -> {String.upcase(k),v} end)
			|> Enum.into(%{})
			|> Dict.get(name, default)
 	end
end
