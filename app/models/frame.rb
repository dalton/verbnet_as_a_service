class Frame
  include Mongoid::Document
  embeds_one :description
  embeds_many :examples
  embeds_one :syntax
  embeds_one :semantics
end
