require "http/server"

class IndexHandler
  include HTTP::Handler

  def call(ctx)
    if ctx.request.path == "/"
      ctx.request.path = "/index.html"
    end
    call_next(ctx)
  end
end
