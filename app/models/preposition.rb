class Preposition < SyntacticUnit
  include Mongoid::Document
  field :value, type: String
  embeds_one :selectional_restriction


  def to_s
    "PREP"
  end
end
