class NounPhrase < SyntacticUnit
  include Mongoid::Document
  field :value, type: String
  embeds_one :selectional_restriction
  embeds_many :syntactic_restrictions


  def to_s
    value
  end
end
