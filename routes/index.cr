require "http/server"

class IndexHandler
  include HTTP::Handler

  def call(ctx)
    if ctx.request.path == "/"
      ctx.request.path = "/index.html"
    end
    if ctx.request.path.starts_with?("/i/")
      ctx.request.path = ctx.request.path.gsub("/i/", "")
    end
    call_next(ctx)
  end
end
