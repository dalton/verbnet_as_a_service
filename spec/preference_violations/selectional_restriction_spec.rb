require 'spec_helper'

describe SelectionalRestriction do
  it "should accept arguments that fit it's type" do
    sr = SelectionalRestriction.new(value: '+', type: 'animate')
    sr.accepts?('sailor').should == true
    sr.accepts?('dog').should == true
    sr.accepts?('person').should == true
    sr.accepts?('brick').should == true
    sr.accepts?('employee').should == true
    sr.accepts?('boss').should == true
    sr.accepts?('phone').should == false
    sr.accepts?('lamp').should == false
    sr.accepts?('cloud').should == false
    sr.accepts?('dirt').should == false
    sr.accepts?('wall').should == false
  end

  it "a superclass should be satisfied by all arguments that satisfy a subclass" do
    sr = SelectionalRestriction.new(value: '+', type: 'natural')
    sr.accepts?('sailor').should == true
    sr.accepts?('dog').should == true
    sr.accepts?('person').should == true
    sr.accepts?('brick').should == true
    sr.accepts?('employee').should == true
    sr.accepts?('tree').should == true
    sr.accepts?('arm').should == true
    sr.accepts?('flower').should == true
    sr.accepts?('boss').should == true
    sr.accepts?('phone').should == false
    sr.accepts?('lamp').should == false
    sr.accepts?('cloud').should == false
    sr.accepts?('dirt').should == false
    sr.accepts?('wall').should == false
  end
end