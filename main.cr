require "http/server"

require "./routes/index"
require "./routes/ping"
require "./routes/upload"

# Create data directory if it doesn't exist
DATA_DIR="./i/"
Dir.mkdir_p(DATA_DIR)

# Start http server
HTTP::Server.new("0.0.0.0", 8080, [
                   # Common handlers
                   HTTP::LogHandler.new,
                   # Routes
                   PingHandler.new,
                   IndexHandler.new,
                   UploadHandler.new(DATA_DIR),
                   # Serve images
                   HTTP::StaticFileHandler.new("./i", directory_listing=false),
                   # Static assets
                   HTTP::StaticFileHandler.new("./html", directory_listing=false),
                   # Final error page
                   HTTP::ErrorHandler.new, # TODO(adam): what does this do?
                 ]).listen
