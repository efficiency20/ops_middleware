require "spec_helper"

describe E20::Ops::Middleware::TransactionIdMiddleware do
  let(:app)    { Proc.new { |env| [200, {}, "OK!"] } }
  let(:uuid)   { stub(:call => "abc123") }
  let(:logger) { Logger.new(StringIO.new) }

  it "is initialized with an app" do
    E20::Ops::Middleware::TransactionIdMiddleware.new(app)
  end

  it "delegates to the app" do
    middleware = E20::Ops::Middleware::TransactionIdMiddleware.new(app, :logger => logger)
    status, headers, body = middleware.call({})
    body.should == "OK!"
  end

  it "sets an X-Transaction header" do
    middleware = E20::Ops::Middleware::TransactionIdMiddleware.new(app, :uuid_generator => uuid, :logger => logger)
    status, headers, body = middleware.call({})
    headers["X-Transaction"].should == "abc123"
  end

  it "logs a line for each request" do
    log_io = StringIO.new
    middleware = E20::Ops::Middleware::TransactionIdMiddleware.new(app, :uuid_generator => uuid, :logger => Logger.new(log_io))
    middleware.call({})
    log_io.string.should include("[E20::Ops::Middleware::TransactionIdMiddleware] Transaction ID: abc123")
  end
end
