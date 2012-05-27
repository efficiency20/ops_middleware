require "uuid"
require "logger"

module E20
  module Ops
    module Middleware
      class TransactionIdMiddleware

        def initialize(app, options = {})
          @app = app
          @uuid_generator = options[:uuid_generator] || UUID.method(:generate)
          @logger = options[:logger] || Logger.new(STDOUT)
        end

        def call(env)
          uuid = @uuid_generator.call.to_s

          status, headers, body = @app.call(env)
          @logger.info "[#{self.class.name}] Transaction ID: #{uuid}"
          headers["X-Transaction"] = uuid
          [status, headers, body]
        end

      end
    end
  end
end
