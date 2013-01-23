class Lex < SyntacticUnit
  include Mongoid::Document
  field :value, type: String


  def to_s
    "LEX"
  end
end
