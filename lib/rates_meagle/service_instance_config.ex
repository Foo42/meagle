defmodule RatesMeagle.Config do
	def all do
		%{"query" => [
			"http://rates-query-int.laterooms.com/status",
			"http://rates-query-qa.laterooms.com/status"
		]}
	end
end
