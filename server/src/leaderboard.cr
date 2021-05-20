require "./user.cr"

class Leaderboard
	getter scores = [] of NamedTuple(user: User, score: Int64)

	def initialize(rows)
		rows.each do
			@scores << {
				user:	User.new(user_id: rows.read(Int64), name: rows.read(String)),
				score: rows.read(Int64),
			}
		end
	end

	def to_json(json_builder json : JSON::Builder)
		json.array do
			@scores.each do |score|
				json.object do
					json.field "score", score[:score]
					json.field "user" do
						score[:user].to_json json
					end
				end
			end
		end
	end
end
