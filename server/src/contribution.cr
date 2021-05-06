class Contribution
    property contribution_id : Nil | Int64
    property user_id : Nil | Int64
    property type : Nil | Int64
    property changeset : Nil | Int64
    property score : Nil | Int64
    property date_time : Nil | Time

    def initialize (
            #@contribution_id = nil,
            @user_id = nil,
            @type = nil,
            @changeset = nil,
            @score = nil,
            @date_time = nil
        )
    end

    def self.from_json (json_obj)
        Contribution.new(
            #contribution_id = json_obj["contributionid"].as(Int64),
            user_id = json_obj["id"].as(Int64),
            type = json_obj["type"].as(Int64),
            changeset = json_obj["changeset"].as(Int64),
            score = json_obj["score"].as(Int64),
            date_time = Time.parse_iso8601(json_obj["datetime"].as(String))
        )
    end
end
