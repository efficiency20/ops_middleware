require "spec_helper"

describe E20::Ops::Hostname do
  it "returns the hostname" do
    hostname = E20::Ops::Hostname.new
    hostname.should_receive(:`).with("hostname").and_return("Computer.local\n")
    hostname.to_s.should == "Computer.local"
  end
end
