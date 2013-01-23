class VerbnetClass
  include Mongoid::Document
  recursively_embeds_many
  field :name, type: String
  embeds_many :members
  embeds_many :thematic_roles
  embeds_many :frames
end
