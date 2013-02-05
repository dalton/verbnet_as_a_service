require 'spec_helper'
describe VerbnetClass do

  it "should respond to arguments" do
    consume = VerbnetClass.where(name: 'consume-66').first
    consume.response_to_arguments('Agent' => 'person').should == 'preferred'
    consume.response_to_arguments('Agent' => 'phone').should == 'violation'

  end

  it "should be searchable by name and member name" do
    VerbnetClass.search("accept").should ==
        {
            members:
                ['accept-77', 'characterize-29.2-1-1', 'obtain-13.5.2'],
            classes: ['accept-77']
        }
  end

end
