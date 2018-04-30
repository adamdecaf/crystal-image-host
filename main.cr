require "http/server"

require "./routes/index"
require "./routes/ping"

HTTP::Server.new("0.0.0.0", 8080, [
                   # Common handlers
                   HTTP::LogHandler.new,
                   # Routes
                   PingHandler.new,
                   IndexHandler.new,
                   # Static assetsn
                   HTTP::StaticFileHandler.new("./html/", directory_listing=false),
                 ]).listen
