require 'spec_helper'
describe "search" do
  it "should be able to find all members for a verb" do
    results = VerbnetClass.with_members("accept")
    results.should include VerbnetClass.where(name: "accept-77").first
    results.should include VerbnetClass.where(name: "obtain-13.5.2").first
    results = VerbnetClass.with_members("eat")
    results.collect(&:name).should == ["eat-39.1-1"]
  end
  it "it should find members in subclasses" do
    results = VerbnetClass.with_members("despise")
    results.collect(&:name).should include "admire-31.2-1"
  end
  it "should be able to find any verb class by name, even if it's a subclass" do
    result = VerbnetClass.named('admire-31.2')
    result.collect(&:name).should == ['admire-31.2','admire-31.2-1']
    result = VerbnetClass.named('admire-31.2-1')
    result.collect(&:name).should == ['admire-31.2-1']
  end
end