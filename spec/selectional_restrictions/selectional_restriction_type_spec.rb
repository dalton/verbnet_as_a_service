require 'spec_helper'

describe SelectionalRestrictionType do
  srt = SelectionalRestrictionType.where(value: 'human').first
  it "should be satisfied by person" do
    srt.should be_satisfied_by("sailor")
  end
  it "should not be satisfied by phone" do
    srt.should_not be_satisfied_by("phone")
  end
end