class Verb  < SyntacticUnit
  include Mongoid::Document

  def to_s
    "V"
  end
end
