module E20
  module Ops
    module Middleware
      class HostnameMiddleware

        def initialize(app, options = {})
          @app = app
          @hostname = options[:hostname] || Hostname.new

          if (logger = options[:logger])
            logger.info "[#{self.class.name}] Running on: #{@hostname}"
          end
        end

        def call(env)
          status, headers, body = @app.call(env)
          headers["X-Served-By"] = @hostname.to_s
          [status, headers, body]
        end

      end
    end
  end
end
