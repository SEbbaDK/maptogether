require "db"
require "pg"
require "./mock-data.cr"

module DbMock
	extend self
	def mockUsers(connection)
		connection.exec MockData.users
	end
end 