require "spec_helper"

describe E20::Ops::Middleware::RevisionMiddleware do
  let(:app) { Proc.new { |env| [200, {}, "OK!"] } }

  it "is initialized with an app" do
    E20::Ops::Middleware::RevisionMiddleware.new(app)
  end

  context "/system/revision" do
    it "returns the current running revision" do
      middleware = E20::Ops::Middleware::RevisionMiddleware.new(app, :revision => "rev")
      status, headers, body = middleware.call({"PATH_INFO" => "/system/revision"})
      body.should == ["rev\n"]
    end
  end

  context "any other endpoint" do
    it "delegates to the app" do
      middleware = E20::Ops::Middleware::RevisionMiddleware.new(app)
      status, headers, body = middleware.call({})
      body.should == "OK!"
    end

    it "logs the running revision when initialized" do
      log_io = StringIO.new
      E20::Ops::Middleware::RevisionMiddleware.new(app, :revision => "rev", :logger => Logger.new(log_io))
      log_io.string.should include("[E20::Ops::Middleware::RevisionMiddleware] Running: rev")
    end

    it "sets an X-Revision header" do
      middleware = E20::Ops::Middleware::RevisionMiddleware.new(app, :revision => "the_revision", :logger => nil)
      status, headers, body = middleware.call({})
      headers["X-Revision"].should == "the_revision"
    end
    
    it "returns the current running revision when configured outside /system/revision" do
      middleware = E20::Ops::Middleware::RevisionMiddleware.new(app, :revision => "rev", :path_info => '/git/revision')
      status, headers, body = middleware.call({"PATH_INFO" => "/git/revision"})
      body.should == ["rev\n"]
    end
  end
end
