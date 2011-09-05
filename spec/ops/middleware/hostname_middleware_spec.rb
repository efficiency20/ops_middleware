require "spec_helper"

describe E20::Ops::Middleware::HostnameMiddleware do
  let(:app) { Proc.new { |env| [200, {}, "OK!"] } }

  it "is initialized with an app" do
    E20::Ops::Middleware::HostnameMiddleware.new(app)
  end

  it "delegates to the app" do
    middleware = E20::Ops::Middleware::HostnameMiddleware.new(app)
    status, headers, body = middleware.call({})
    body.should == "OK!"
  end

  it "logs the hostname when initialized" do
    log_io = StringIO.new
    middleware = E20::Ops::Middleware::HostnameMiddleware.new(app, :logger => Logger.new(log_io))
    status, headers, body = middleware.call({})
    log_io.string.should include("[E20::Ops::Middleware::HostnameMiddleware] Running on: ")
  end

  it "sets an X-Served-By header" do
    middleware = E20::Ops::Middleware::HostnameMiddleware.new(app, :hostname => "Computer.local")
    status, headers, body = middleware.call({})
    headers["X-Served-By"].should == "Computer.local"
  end
end
