require "uuidtools"
require "logger"

module E20
  module Ops
    module Middleware
      class TransactionIdMiddleware

        def initialize(app, options = {})
          @app = app
          @uuid_generator = options[:uuid_generator] || UUIDTools::UUID.method(:random_create)
          @logger = options[:logger] || Logger.new(STDOUT)
        end

        def call(env)
          uuid = @uuid_generator.call.to_s
          @logger.info "[#{self.class.name}] Transaction ID: #{uuid}"

          status, headers, body = @app.call(env)
          headers["X-Transaction"] = uuid
          [status, headers, body]
        end

      end
    end
  end
end
