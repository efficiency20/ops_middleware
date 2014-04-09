module E20
  module Ops
    module Middleware
      class RevisionMiddleware

        def initialize(app, options = {})
          @app = app
          @revision = options[:revision] || Revision.new
          @path_info = options[:path_info] || '/system/revision'

          if (logger = options[:logger])
            logger.info "[#{self.class.name}] Running: #{@revision}"
          end
        end

        def call(env)
          if env["PATH_INFO"] == @path_info
            body = "#{@revision}\n"
            [200, { "Content-Type" => "text/plain", "Content-Length" => body.size.to_s }, [body]]
          else
            status, headers, body = @app.call(env)
            headers["X-Revision"] = @revision.to_s
            [status, headers, body]
          end
        end

      end
    end
  end
end
