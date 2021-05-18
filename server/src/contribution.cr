class Contribution
	property contribution_id : Nil | Int64
	property user_id : Int64
	property type : Int64
	property changeset : Int64
	property score : Int64
	property date_time : Time

	def initialize(
		@user_id,
		@type,
		@changeset,
		@score,
		@date_time,
		@contribution_id = nil
	)
	end

	def self.from_json(json_obj)
		# contribution_id: json_obj["contributionid"]?.as(Int64 | Nil),
		contribution = Contribution.new(
			user_id: json_obj["id"].as(Int64),
			type: json_obj["type"].as(Int64),
			changeset: json_obj["changeset"].as(Int64),
			score: json_obj["score"].as(Int64),
			date_time: Time.parse_iso8601(json_obj.["datetime"].as(String)),
		)
	end
end
