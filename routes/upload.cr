require "file"
require "http"
require "http/server"
require "tempfile"
require "openssl"

class UploadHandler
  include HTTP::Handler

  def initialize(data_dir : String)
    @data_dir = data_dir
  end

  def call(ctx)
    if ctx.request.method == "POST" && ctx.request.path == "/upload"
      # TODO(adam): Check content-length

      HTTP::FormData.parse(ctx.request) do |part|
        if part.name == "file"
          file = Tempfile.open("upload") do |file|
            IO.copy(part.body, file) # TODO(adam): Check content-length
          end

          # Find file checksum to rename
          f = File.open(file.path)
          hasher = OpenSSL::Digest.new("SHA256")
          hasher.update f

          # TODO(adam): reject based on content type

          # Generate new path
          checksum = hasher.hexdigest[0, 16]
          ext = File.extname(File.basename(part.filename || "ukn")) # TODO(adam): detect content type
          name = "#{checksum}#{ext}"
          path = File.join([@data_dir, name])

          # Move uploaded file
          File.rename(file.path, path) unless File.exists?(path)

          # Set response
          ctx.response.status_code = 302
          ctx.response.headers.add("Location", "/i/#{name}")

          return # quit early after successful upload
        end
      end
    end
    call_next(ctx)
  end
end
