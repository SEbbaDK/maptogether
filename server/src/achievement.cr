class Achievement
	property name : String
	property description : String

	def initialize(@name, @description)
	end

	def to_json(json_builder json : JSON::Builder)
		json.object do
			json.field "name", name
			json.field "description", description
		end
	end
end
