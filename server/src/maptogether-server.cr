require "kemal"
require "db"
require "pg"
require "json"
require "../dbmock/*"


module MapTogether::Server

    DB.connect "postgres://maptogether:maptogether@localhost:5432/maptogether?retry_attempts=100" do |cnn|
      cnn.exec "CREATE SEQUENCE IF NOT EXISTS user_id start 1"
      puts typeof(cnn)
      cnn.exec "CREATE TABLE IF NOT EXISTS users (
      userID integer NOT NULL DEFAULT nextval('user_id') PRIMARY KEY,
      name varchar(20),
      score integer)"
      puts typeof(cnn)
      cnn.exec "insert into users values (DEFAULT, $1, $2)", "Hanne", 69420
      DbMock.mockUsers(cnn)
      cnn.query "select userID, name, score from users order by userID asc" do |ra|
        ra.each do
          id = ra.read(Int32)
          name = ra.read(String)
          score = ra.read(Int32)
          puts "(#{id}) #{name} (#{score})"
        end
      end
      cnn.exec "DELETE FROM users where userID > 3"
      cnn.query "select userID, name, score from users order by userID asc" do |ra2|
          ra2.each do
              id = ra2.read(Int32)
              name = ra2.read(String)
              score = ra2.read(Int32)
              puts "(#{id}) #{name} (#{score})"
          end
      end

      #loop do
         # pp cnn.scalar("SELECT NOW()")
          #sleep 0.5
        #end

    end

    #get "/" do
        #"hi"
    #end

    get "/user/:id" do |env|
        string = JSON.build do |json|
            json.object do
                id = env.params.url["id"]
                DB.connect "postgres://maptogether:maptogether@localhost:5432/maptogether?retry_attempts=100" do |cnn|
                    cnn.query "select userID, name, score from users where userID = $1", id do |rs|
                        rs.each do
                            userid = rs.read(Int32)
                            name = rs.read(String)
                            score = rs.read(Int32)
                            json.field "id", userid
                            json.field "name", name
                            json.field "score", score
                            puts "#{userid} #{name} #{score}"
                        end
                    end
                end
            end
        end
        string
    end

    get "/leaderboard/global/all_time" do |env|
        string = JSON.build do |json|
            counter = 1
            json.object do
                DB.connect "postgres://maptogether:maptogether@localhost:5432/maptogether?retry_attempts=100" do |cnn|
                    cnn.query "SELECT userID, name, score FROM users ORDER BY score DESC" do |users|
                        json.field "users" do
                            json.array do
                                users.each do
                                    userid = users.read(Int32)
                                    name = users.read(String)
                                    score = users.read(Int32)
                                    json.object do
                                        json.field "placement", counter
                                        json.field "userID", userid
                                        json.field "name", name
                                        json.field "score", score
                                    end
                                    counter += 1
                                end
                            end
                        end
                    end
                end
            end
        end
        string
    end

    get "/" do |env|

    end

    Kemal.run 8080



end

