class Argument
  include Mongoid::Document
  field :type, type: String
  field :value, type: String
end
