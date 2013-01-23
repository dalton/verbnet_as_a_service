class Syntax
  include Mongoid::Document
  embeds_many :syntactic_units
end
