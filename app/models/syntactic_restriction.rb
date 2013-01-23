class SyntacticRestriction
  include Mongoid::Document
  field :value, type: String
  field :type, type: String
  field :logic, type: String
  embeds_many :syntactical_restrictions
end
