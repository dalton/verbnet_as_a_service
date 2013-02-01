require 'spec_helper'
describe "search" do
  it "should be able to find all members for a verb" do
    results = VerbnetClass.search("members.name", "accept").to_a
    results.should include VerbnetClass.where(name: "accept-77").first
    results.should include VerbnetClass.where(name: "obtain-13.5.2").first
  end
  it "it should find members in subclasses" do
    results = VerbnetClass.search("members.name", "despise")
    results.should include VerbnetClass.search('name', "admire-31.2-1").first
    results = VerbnetClass.search("name", "admire-31.2-1").first
    results.name.should == "admire-31.2-1"

  end
end