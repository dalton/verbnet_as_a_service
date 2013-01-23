require 'spec_helper'

describe "to_xml" do
  it "should reproduce the VerbNet XML" do

    files = Dir.glob("./data/verbnet/*.xml")
    f = open files[0]

    x = Crack::XML.parse f

    ingester = Ingesters::VerbnetClassIngester.new
    ingester.ingest x

    Crack::XML.parse(VerbnetClass.first.to_xml).should == x


  end
end