class Adverb < SyntacticUnit
  include Mongoid::Document

  def to_s
    "ADV"
  end
end
