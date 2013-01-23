class Adjective < SyntacticUnit
  include Mongoid::Document

  def to_s
    "ADJ"
  end
end
