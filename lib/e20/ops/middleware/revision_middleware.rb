module E20
  module Ops
    module Middleware
      class RevisionMiddleware

        def initialize(app, options = {})
          @app = app
          @options = options
          @revision = options[:revision] || Revision.new
        end

        def call(env)
          
          response = if env["PATH_INFO"] == "/system/revision"
            body = "#{@revision}\n"
            [200, { "Content-Type" => "text/plain", "Content-Length" => body.size.to_s }, [body]]
          else
            status, headers, body = @app.call(env)
            headers["X-Revision"] = @revision.to_s
            [status, headers, body]
          end
          
          if (logger = @options[:logger])
            logger.info "[#{self.class.name}] Running: #{@revision}"
          end
          
          response
        end

      end
    end
  end
end
