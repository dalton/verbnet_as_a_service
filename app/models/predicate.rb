class Predicate
  include Mongoid::Document
  field :bool, type: String
  field :value, type: String
  embeds_many :arguments
end
