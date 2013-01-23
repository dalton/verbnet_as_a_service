class Semantics
  include Mongoid::Document
  embeds_many :predicates
end
