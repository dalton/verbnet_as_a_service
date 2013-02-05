require 'spec_helper'

describe SelectionalRestriction do
  sr = VerbnetClass.first.thematic_roles.first.selectional_restriction
  it "should be satisfied by words that match" do
    sr.should be_satisfied_by("person")
  end
  it "should be not be satisfied by words that do not match" do
    sr.should_not be_satisfied_by("phone")
  end
end