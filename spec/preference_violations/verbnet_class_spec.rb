require 'spec_helper'
describe VerbnetClass do

  it "should respond to arguments" do
    consume = VerbnetClass.where(name: 'consume-66').first
    consume.response_to_arguments('Agent' => 'person').should == 'preferred'
    consume.response_to_arguments('Agent' => 'phone').should == 'violation'

    build = VerbnetClass.named('build-26.1-1').first
    build.response_to_arguments('Material' => 'silk').should == 'preferred'
    build.response_to_arguments('Material' => 'charter').should == 'violation'

  end

  it "should be searchable by name and member name" do
    result = VerbnetClass.search("accept")
    result[:members].collect(&:name).should == ['accept-77', 'characterize-29.2-1-1', 'obtain-13.5.2']
    result[:classes].collect(&:name).should == ['accept-77']
  end

  it "returns just the names from searches when asked to" do
    result = VerbnetClass.name_search("accept")
    result[:members].should == ['accept-77', 'characterize-29.2-1-1', 'obtain-13.5.2']
    result[:classes].should == ['accept-77']

  end

end
