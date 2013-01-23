class SelectionalRestriction
  include Mongoid::Document
  recursively_embeds_many
  field :value, type: String
  field :type, type: String
  field :logic, type: String
end
