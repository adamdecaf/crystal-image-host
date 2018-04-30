require "http/server"

class PingHandler
  include HTTP::Handler

  def call(ctx)
    if ctx.request.path == "/ping"
      ctx.response.content_type = "text/plain"
      ctx.response.print "PONG"
    else
      call_next(ctx)
    end
  end
end
