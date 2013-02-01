require 'spec_helper'
describe VerbnetClass do

  it "should respond to arguments" do
    consume = VerbnetClass.where(name: 'consume-66').first
    consume.response_to_arguments('Agent' => 'person').should == 'preferred'
    consume.response_to_arguments('Agent' => 'phone').should == 'violation'

  end

end
