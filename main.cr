require "http/server"

require "./routes/index"
require "./routes/ping"
require "./routes/upload"

# Create data directory if it doesn't exist
DATA_DIR="./data"
Dir.mkdir_p(DATA_DIR)

# Start http server
HTTP::Server.new("0.0.0.0", 8080, [
                   # Common handlers
                   HTTP::LogHandler.new,
                   # Routes
                   PingHandler.new,
                   IndexHandler.new,
                   UploadHandler.new(DATA_DIR),
                   # Static assetsn
                   HTTP::StaticFileHandler.new("./html/", directory_listing=false),
                   HTTP::ErrorHandler.new,
                 ]).listen
