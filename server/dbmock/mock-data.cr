module DbMock
	class MockData
		@@users = "
		INSERT INTO users(name, score) VALUES
			(Hanne, 10),
			(Kim, 50),
			(Karl, 100)
		"

		def self.users
			@@users
		end
	end
end