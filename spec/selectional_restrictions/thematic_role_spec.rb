require 'spec_helper'

describe ThematicRole do
  it "should print out the selectional restriction in VerbNet format" do
    accept = VerbnetClass.where(name: 'accept-77').first
    accept.thematic_roles.first.selectional_restriction.to_s.should == "[+animate | +organization]"

    steal = VerbnetClass.where(name: 'steal-10.5').first
    steal.thematic_roles[2].selectional_restriction.to_s.should == "[+animate | [+location & -region]]"
  end
end