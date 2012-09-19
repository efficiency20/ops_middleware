require "logger"

module E20
  module Ops
    module Middleware
      class TransactionIdMiddleware

        def initialize(app, options = {})
          @app = app
          @uuid_generator = options[:uuid_generator] || find_uuid_generator
          @logger = options[:logger] || Logger.new(STDOUT)
        end

        def call(env)
          uuid = @uuid_generator.call.to_s
          @logger.info "[#{self.class.name}] Transaction ID: #{uuid}"

          status, headers, body = @app.call(env)
          headers["X-Transaction"] = uuid
          [status, headers, body]
        end

        def find_uuid_generator
          require 'securerandom'
          return SecureRandom.method(:uuid) if SecureRandom.respond_to?(:uuid)

          require 'uuid'
          UUID.method(:generate)
        end

      end
    end
  end
end
