require "spec_helper"

describe E20::Ops::Revision do
  context "when a REVISION file is present" do
    it "adds a X-Revision header with the REVISION" do
      tmp_path = Pathname.new(Dir.tmpdir)
      tmp_path.join("REVISION").open("w") { |f| f.write "hello\n" }
      E20::Ops::Revision.new(tmp_path).to_s.should == "hello"
    end
  end

  context "when a REVISION file is not present" do
    it "adds a X-Revision header with the git rev-parse HEAD" do
      revision = E20::Ops::Revision.new
      revision.should_receive(:`).with("git rev-parse HEAD").and_return("abc123")
      revision.to_s.should == "abc123"
    end
  end

  context "when neither a REVISION file or a git revision are available" do
    it "adds a X-Revision header of 'unknown'" do
      revision = E20::Ops::Revision.new
      revision.stub(:` => "")
      revision.to_s.should == "unknown"
    end
  end
end
